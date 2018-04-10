using Godot;
using System;
using FinalProject.Hexasphere;
using System.Collections.Generic;
using FinalProject.MeshUtilities;

public class HexasphereNode : Node
{
    List<Spatial> hexInstances = new List<Spatial>();
    PackedScene redSphereMeshScene, greenSphereMeshScene, blueSphereMeshScene, centerStandingPlatform;
    List<PackedScene> hexagons = new List<PackedScene>();
    List<PackedScene> pentagons = new List<PackedScene>();
    Random random = new Random();
    public override void _Ready()
    {
        //Load the instances to put in the scene
        //Load the debug assets
        centerStandingPlatform = (PackedScene)ResourceLoader.Load("res://Common/Assets/MeshInstance.tscn");
        blueSphereMeshScene = (PackedScene)ResourceLoader.Load("res://Common/Assets/Blue Sphere.tscn");
        greenSphereMeshScene = (PackedScene)ResourceLoader.Load("res://Common/Assets/Green Sphere.tscn");
        redSphereMeshScene = (PackedScene)ResourceLoader.Load("res://Common/Assets/Red Sphere.tscn");
        
        //pentagons.Add((PackedScene)ResourceLoader.Load("res://Pentagon Levels/Filip/pentagon_level.tscn"));
		//hexagons.Add((PackedScene)ResourceLoader.Load("res://Pentagon Levels/Filip/pentagon_level.tscn"));
		
		//pentagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Jan/hexa_maze.tscn"));
		//pentagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Jan/simpler_hexa_maze.tscn"));
		//hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Jan/hexa_maze.tscn"));
		
		//hexagons.Add((PackedScene)ResourceLoader.Load("res://Common/Assets/Hexagon.tscn"));
		//hexagons.Add((PackedScene)ResourceLoader.Load("res://Common/Assets/Hexagon.tscn"));
		hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Jan/simpler_hexa_maze.tscn"));
		hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Jan/hexa_maze.tscn"));
		hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Scott/level.tscn"));
		hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Pavel/world1.tscn"));
		hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Generic Square Maze/Generic Maze.tscn"));
		//pentagons.Add((PackedScene)ResourceLoader.Load("res://pentagon_levels/filip/pentagon_level.tscn"));
		pentagons.Add((PackedScene)ResourceLoader.Load("res://pentagon_levels/Tree/TreePentagon.tscn"));
		pentagons.Add((PackedScene)ResourceLoader.Load("res://pentagon_levels/filip/pentagon_level.tscn"));
		
        //pentagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Jacob/Main Scene.tscn"));		
		
        //hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Pavel/world1.tscn"));
		
		//hexagons.Add((PackedScene)ResourceLoader.Load("res://Common/Assets/Hexagon.tscn"));
        //pentagons.Add((PackedScene)ResourceLoader.Load("res://Common/Assets/Pentagon.tscn"));
        //hexagons.Add((PackedScene)ResourceLoader.Load("res://Hexagon Levels/Generic Square Maze/Generic Maze.tscn"));
        
		//Define sphere properties
        float radius = 95;
        int subdivisionCount = 3;

        //h is used for creating full size tiles
        Hexasphere hexasphere = new Hexasphere((decimal)radius, subdivisionCount, 1);

        GD.Print("Number of Tiles: " + hexasphere.GetTiles().Count);
		
        var numberOfTiles = hexasphere.GetTiles().Count;
        //Create all the scenes that appear on tiles
        foreach (var tile in hexasphere.GetTiles()) {
            CreateSceneOnTile(tile, radius / numberOfTiles);
            CreateMeshForTile(tile, radius / numberOfTiles);
        }
    }

    private Spatial GetRandomHexagon() {
        if (hexagons.Count == 0) {
            return null;
        }
        return (Spatial)hexagons[random.Next(hexagons.Count)].Instance();
    }

    private Spatial GetRandomPentagon()
    {
        if (pentagons.Count == 0)
        {
            return null;
        }
        return (Spatial)pentagons[random.Next(pentagons.Count)].Instance();
    }

    // Creates the hexagon or pentagon instance for the tile.
    private void CreateSceneOnTile(Tile tile, float sphereScale) {
        decimal tileCenterX = 0;
        decimal tileCenterY = 0;
        decimal tileCenterZ = 0;
        decimal polygonRadius = 0;

        List<Point> points = tile.boundary;

        //Calculate the average center point and polygon side length.
        var lastPoint = points[points.Count - 1];
        Vector3 lastPointVector = new Vector3((float)lastPoint.x, (float)lastPoint.y, (float)lastPoint.z);
        decimal polygonSideLength = 0;
        foreach (Point point in points)
        {
            tileCenterX += point.x / points.Count;
            tileCenterY += point.y / points.Count;
            tileCenterZ += point.z / points.Count;
            Vector3 currentVector = new Vector3((float)point.x, (float)point.y, (float)point.z);
            polygonSideLength += (decimal)currentVector.DistanceTo(lastPointVector);
            lastPointVector = currentVector;
        }
        polygonSideLength = polygonSideLength / points.Count;

        //Create the center point
        var tileCenterPoint = new Vector3((float)tileCenterX, (float)tileCenterY, (float)tileCenterZ);
        var firstPoint = new Vector3((float)points[0].x, (float)points[0].y, (float)points[0].z);

        //Get the average polygon radius from center to each point.
        foreach (Point point in points)
        {
            var vector = new Vector3((float)point.x, (float)point.y, (float)point.z);
            polygonRadius += (decimal)vector.DistanceTo(tileCenterPoint);
        }
        polygonRadius = polygonRadius / points.Count;

        var sphereCenterPoint = new Vector3(0f, 0f, 0f);

        //Create the debug spheres to go on each tile
        MeshInstance sphere = (MeshInstance)blueSphereMeshScene.Instance();
        sphere.SetTranslation(tileCenterPoint);
        sphere.SetScale(new Vector3(sphereScale, sphereScale, sphereScale));
        this.AddChild(sphere);

        MeshInstance sphere2 = (MeshInstance)greenSphereMeshScene.Instance();
        sphere2.SetTranslation(firstPoint);
        sphere2.SetScale(new Vector3(sphereScale, sphereScale, sphereScale));
        this.AddChild(sphere2);

        MeshInstance sphere3 = (MeshInstance)greenSphereMeshScene.Instance();
        sphere3.SetTranslation((firstPoint - tileCenterPoint) / 2 + tileCenterPoint);
        sphere3.SetScale(new Vector3(sphereScale, sphereScale, sphereScale));
        this.AddChild(sphere3);

        //Create the tile instance
        Spatial groundTest = null;
        if (points.Count == 5)
        {
            //GD.Print("Pentagon Radius: " + polygonRadius + ", side length: " + polygonSideLength);
            //Create instance
            groundTest = GetRandomPentagon();
        }
        else if (points.Count == 6)
        {
            //GD.Print("Hexagon Radius: " + polygonRadius + ", side length: " + polygonSideLength);
            //Create instance
            groundTest = GetRandomHexagon();
        }
        else
        {
            //GD.Print("Unknown Radius: " + polygonRadius + ", Count: " + points.Count + ", Side Length: " + polygonSideLength);
        }
        if (groundTest != null)
        {
            //Put the instance on the tile and make it face the center of the sphere
            //This should be all that is needed but the sections are rotated perpendicular
            groundTest.LookAtFromPosition(tileCenterPoint, sphereCenterPoint, new Vector3(0f, 1f, 0f));
            //Get the local axis of the instance
            var axis = groundTest.GetTransform().basis.Xform(new Vector3(-1, 0, 0)).Normalized();
            //Rotate it to face the center (I have no idea why this is necessary)
            groundTest.Rotate(axis, (float)(Math.PI / 2.0));
            //Get the local axis of the instance
            var axis2 = groundTest.GetTransform().basis.Xform(new Vector3(0, 1, 0)).Normalized();
            //Add ground to world
            this.AddChild(groundTest);
            this.hexInstances.Add(groundTest);

            //Create and convert local point to world point
            var localOriginalFirstPoint = new Vector3(0, 0, (float)polygonRadius);
            var worldOriginalFirstPoint = groundTest.ToGlobal(localOriginalFirstPoint);

            var worldGeneratedFirstPoint = firstPoint;
            var localGeneratedFirstPoint = groundTest.ToLocal(worldGeneratedFirstPoint);

            MeshInstance redSphere = (MeshInstance)redSphereMeshScene.Instance();
            redSphere.SetTranslation(worldOriginalFirstPoint);
            redSphere.SetScale(new Vector3(sphereScale, sphereScale, sphereScale));
            this.AddChild(redSphere);
            //World Original First Point works and is correct
            //Now is there a way I can get the two points and match them up?
            var angleCalcOriginalPoint = worldOriginalFirstPoint - tileCenterPoint;
            var angleCalcFirstPoint = firstPoint - tileCenterPoint;

            var angle = angleCalcFirstPoint.AngleTo(angleCalcOriginalPoint);
            var angle2 = new Vector2(localGeneratedFirstPoint.x, localGeneratedFirstPoint.z).AngleTo(new Vector2(localOriginalFirstPoint.x, localOriginalFirstPoint.z));


            var axis3 = groundTest.GetTransform().basis.Xform(new Vector3(0, 1, 0));
            if (points.Count == 5) {
                angle2 += (float)Math.PI / 4;
            }
            //angleCalcFirstPoint.
            //Rotate it to match up with other parts of the sphere
            groundTest.Rotate(axis3, angle2);



            var newWorldPoint = groundTest.ToGlobal(localOriginalFirstPoint);
            //GD.Print("Difference: " + (worldGeneratedFirstPoint - newWorldPoint));
        }
    }

    // Creates a wire mesh and places the spheres to make sure the tile is aligned.
    private void CreateMeshForTile(Tile tile, float sphereScale) {
        //Get tile center point
        decimal tileCenterX = 0;
        decimal tileCenterY = 0;
        decimal tileCenterZ = 0;
        List<Point> points = tile.boundary;
        //Calculate the average center point and polygon side length.
        foreach (Point point in points)
        {
            tileCenterX += point.x / points.Count;
            tileCenterY += point.y / points.Count;
            tileCenterZ += point.z / points.Count;
        }
        //Create the center point
        var tileCenterPoint = new Vector3((float)tileCenterX, (float)tileCenterY, (float)tileCenterZ);
        if (points.Count == 5) {
			tileCenterPoint = tileCenterPoint + (tileCenterPoint.Normalized() * 6);
		}
		GD.Print(tileCenterPoint);

        //Create surface tool
		               var material = new SpatialMaterial();
                //material.SetEmission(new Color(1.0f, 0.0f, 0.0f));
                //material.SetEmissionEnergy(0.5f);
                material.SetAlbedo(new Color(0.0f, 0.0f, 0.0f));
                //material.SetMetallic(0.5f);
                material.SetCullMode(SpatialMaterial.CullMode.Back);
        var surfaceTool = MeshCreation.CreateSurfaceTool(material);
        //Make triangles for polygon
        for (var index = 0; index < points.Count; index++)
        {
            var point = new Vector3((float)points[index].x, (float)points[index].y, (float)points[index].z);
            Vector3 nextPoint;
            if (index < points.Count - 1) {
                nextPoint = new Vector3((float)points[index + 1].x, (float)points[index + 1].y, (float)points[index + 1].z);
            } else {
                nextPoint = new Vector3((float)points[0].x, (float)points[0].y, (float)points[0].z);
            }
			if (points.Count == 5) {
				point = point + (point.Normalized() * 6);
				nextPoint = nextPoint + (nextPoint.Normalized() * 6);
			}
            MeshCreation.AddTriangle(surfaceTool, point, nextPoint, tileCenterPoint, true);
        }
        //Add to scene
        var meshInstance = MeshCreation.CreateMeshInstanceFromMesh(MeshCreation.CreateMeshFromSurfaceTool(surfaceTool));
        this.AddChild(meshInstance);


        /*
        var surfTool = new SurfaceTool();
        var mesh = new ArrayMesh();
        var material = new SpatialMaterial();
        material.SetEmission(new Color(1.0f, 0.0f, 0.0f));
        material.SetAlbedo(new Color(1.0f, 0.0f, 0.0f));
        surfTool.Begin(Mesh.PrimitiveType.TriangleStrip);
        //LineLoop - Nothing
        //Lines - Nothing
        //LineStrip - Nothing
        //Points - Nothing
        //TriangleFan - Nothing
        //Triangles - Nothing
        //TriangleStrip - Nothing
        surfTool.SetMaterial(material);
        decimal tileCenterX = 0;
        decimal tileCenterY = 0;
        decimal tileCenterZ = 0;
        decimal polygonRadius = 0;

        List<Point> points = tile.boundary;
        var lastPoint = points[points.Count - 1];
        Vector3 lastPointVector = new Vector3((float)lastPoint.x, (float)lastPoint.y, (float)lastPoint.z);
        decimal polygonSideLength = 0;
        foreach (Point point in points) {
            surfTool.AddUv(new Vector2(0, 0));
            surfTool.AddVertex(new Vector3((float)point.x, (float)point.y, (float)point.z));

            tileCenterX += point.x / points.Count;
            tileCenterY += point.y / points.Count;
            tileCenterZ += point.z / points.Count;
            Vector3 currentVector = new Vector3((float)point.x, (float)point.y, (float)point.z); 
            polygonSideLength += (decimal)currentVector.DistanceTo(lastPointVector);
            lastPointVector = currentVector;
        }
        polygonSideLength = polygonSideLength / points.Count;

        var tileCenterPoint = new Vector3((float)tileCenterX, (float)tileCenterY, (float)tileCenterZ);
        var firstPoint = new Vector3((float)points[0].x, (float)points[0].y, (float)points[0].z);

        foreach (Point point in points)
        {
            var vector = new Vector3((float) point.x, (float)point.y, (float)point.z);
            polygonRadius += (decimal)vector.DistanceTo(tileCenterPoint);
        }
        polygonRadius = polygonRadius / points.Count;

        var polygonRotation = firstPoint.AngleTo(tileCenterPoint);


        var sphereCenterPoint = new Vector3(0f, 0f, 0f);

        MeshInstance sphere = (MeshInstance)blueSphereMeshScene.Instance();
        sphere.SetTranslation(tileCenterPoint);
        sphere.SetScale(new Vector3(sphereScale, sphereScale, sphereScale));
        this.AddChild(sphere);

        MeshInstance sphere2 = (MeshInstance)greenSphereMeshScene.Instance();
        sphere2.SetTranslation(firstPoint);
        sphere2.SetScale(new Vector3(sphereScale, sphereScale, sphereScale));
        this.AddChild(sphere2);

        MeshInstance sphere3 = (MeshInstance)greenSphereMeshScene.Instance();
        sphere3.SetTranslation((firstPoint - tileCenterPoint) / 2 + tileCenterPoint);
        sphere3.SetScale(new Vector3(sphereScale, sphereScale, sphereScale));
        this.AddChild(sphere3);

        surfTool.GenerateNormals();
        surfTool.Index();
        surfTool.Commit(mesh);
        var meshInstance = new MeshInstance();
        meshInstance.SetMesh(mesh);
        meshInstance.CreateTrimeshCollision();
        this.AddChild(meshInstance);
        */
    }

    //Not used currently
    public override void _Process(float delta)
    {
        // Called every frame. Delta is time since last frame.
        // Update game logic here.
        /*
        foreach (Spatial node in hexInstances) {
            //Get the local axis of the instance
            var axis = node.GetTransform().basis.Xform(new Vector3(0, 1, 0)).Normalized();
            //Rotate it to match up with other parts of the sphere
            node.Rotate(axis, (float)(1.0 / 180 * Math.PI));
        }
        */
    }
}
