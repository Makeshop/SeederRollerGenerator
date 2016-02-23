////////// Open Jang Seeder Roller Generator V1.0////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//
// Edit the values of these parameters to suit your needs/seeds
// Hit F5 key or the preview button to check effect as you go
// Hit Render or F6 key when you are happy, and then "Export as STL"
// The .stl file is a 3D printable format
// Reccommended printer settings: 
// 0.2mm layer height, 3 shells, 30%-50% infill

Identifier = "ABC123";
// Identifier: Text to be printed on face.
// Enter text between the "quotes".
// Text should be 8 characters or less.

WellShape = "crescent";
// enter sphere, crescent or cross between the "quotes".
// For cross the thickness of the grooves is 1/3 Well Diameter.

WellDiameter = 10;
// Diameter in mm of the seed well.

WellDepth = 3;
// Depth of the well from the edge of the roller to bottom
// of the well.

WellsPerRow = 12;
// Number of seed wells per row per revolution.

RollerRows = 2; 
// Enter 1 for a single central row, or 2 for two rows.

RowSpacing = 8;
// Distance from center of the roller to centers of rows of wells 
// as a fraction of the height of the roller.
// Entering a value of 4 equates to 1/4 the height of the roller
// Recommend values between 4 and 8, using higher values when 
// using large wells and offset rows, see below.

RowsOffset = "true";
// If 2 rows, enter "true" for rows where the wells
// alternate, or "false" for rows where the wells are aligned.

/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//
// Created by Ash Watson and Makeshop for Farmhack and Science 
// Gallery Dublin.
//
// This tool is intended to be used for the creation of custom parts
// for the Jang JP-1 or other compatible seeders.
// It is NOT intended as a replacement for the standard range of 
// Jang Seeder rollers.
//
// Some trial and error will be required to get the parameters just
// right for your specific application. 
// 
// Note that 3D printed parts may be more susceptible to wear
//
// This work is licensed under a Creative Commons Attribution 
// 3.0 Unported (CC-by-S.A.) licence.
// Links:
// http://creativecommons.org/licenses/by/3.0/legalcode
// http://creativecommons.org/licenses/by/3.0/
// 
// This is a remix of the custom printable Jang Seeder Rollers
// ceated by Farmhack and Thingiverse user, jellenbogen.
// Links:
// http://farmhack.org/tools/custom-3d-printable-jang-seeder-rollers
// http://www.thingiverse.com/thing:771742 
//
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////

// Jang Seeder Roller Outer Dimensions
RollerDiameter = 60;
RollerRadius = RollerDiameter/2;
RollerHeight = 20;
ShaftDiameter = 15;
ShaftRadius = ShaftDiameter/2;

// Derived Variables
// Angle to increment rotation by
WellAngle = 360/WellsPerRow;
// Angle to offset second/upper row by if RowsOffset is selected
OffAngle = WellAngle/2;
// Spacing height from center if 2 rows
OffHeight = RollerHeight/RowSpacing;
// Diameter for cross pattern
CrossDiameter=WellDiameter/3;

// Build Seeder Roller from modules
difference()
{
    union()
    {
        body();
        //Add flat shaft face
        translate([0,-ShaftRadius,0])
        cube([ShaftDiameter,4,RollerHeight],center=true);
    }
    union()
    {
        // cut out text identifier
        id ();
        // nested if statement calls instances of wells and rotates and transforms them
        if (RollerRows == 2)
        {
            // Lower row of wells
            translate ([0,0,-OffHeight]) wells();
            if (RowsOffset == "true")
            {
                // rotate upper row of wells
                rotate([0,0,OffAngle]) 
                translate([0,0,OffHeight]) 
                wells();
            }
            else if (RowsOffset == "false")
            {
                // upper row of wells, no offset.
                translate([0,0,OffHeight])
                wells();
            }
        }
        else if (RollerRows == 1)
        {
            // just one set of central wells
            wells();
        }
    }
}

module body()
{
    difference()
    {
    // Main Cylinder
    cylinder (d=RollerDiameter,h=RollerHeight,center=true,$fn=180);
    // Shaft Cutout
    cylinder(d=ShaftDiameter,h=RollerHeight+1,center=true,$fn=180);
    }
    
}

module id ()
{
    translate ([0,-RollerRadius/2,RollerHeight/2-2])
    linear_extrude(height=4)
    {
        text (Identifier, font="Arial:style=Bold", size=6, halign="center", valign="center",$fa=5);
    }
}

module wells ()
{
    // Put wells around outside perimeter
    for (a=[0:WellAngle:359])
    {
    rotate ([0,0,a]) translate ([-RollerRadius+(WellDepth-WellDiameter/2),0,0])
        // 3 different well shapes
        {
        // Sphere, a cylider that terminates in a sphere with depth = WellDepth
        if (WellShape == "sphere")
            {
                union ()
                {
                    sphere (d=WellDiameter,center=true,$fn=18);
                    translate([-15,0,0])
                    rotate([0,-90,0])
                    cylinder(d=WellDiameter,h=30,center=true,$fn=18);
                }
            }
        if (WellShape == "crescent")
            {
            difference ()
                {
                    union ()
                    {
                        sphere (d=WellDiameter,center=true,$fn=18);
                        translate([-15,0,0])
                        rotate([0,-90,0])
                        cylinder(d=WellDiameter,h=30,center=true,$fn=18);
                    }
                    translate ([-15,-WellDiameter/4,0])
                    cube ([30+WellDiameter,WellDiameter/2,WellDiameter+1], center=true); 
                }
            }
        if (WellShape == "cross")
            {
                //Adjust well depth for smaller well depth.
                translate ([CrossDiameter,0,0])
                for (b=[0,90])
                    rotate ([b,0,0])
                {
                    hull ()
                    {
                        cylinder (d=CrossDiameter,h=CrossDiameter*2,center=true,$fn=18);
                        translate ([0,0,-CrossDiameter])
                        sphere (d=CrossDiameter,center=true,$fn=18);
                        translate ([0,0,CrossDiameter]) 
                        sphere (d=CrossDiameter,center=true,$fn=18);
                        translate([-15,0,CrossDiameter]) 
                        rotate([0,-90,0]) 
                        cylinder (d=CrossDiameter, h=30, center=true,$fn=18);
                        translate([-15,0,-CrossDiameter]) 
                        rotate([0,-90,0]) 
                        cylinder (d=CrossDiameter, h=30, center=true,$fn=18);
                    }   
                }
            }
        }
    }
}

