
// ===== PARAMETERS ===== //

/* [Parts] */
item_parts = 0; // [0:Complete, 1:Holder Test, 2:Bracket Test, 3:Test]

/* [Phone Dimension] */
// Width of Phone
phone_width = 77;  
// Thickness of Phone
phone_thickness = 12;  
// Length from bottom of phone to just below first buttons on the sides
holder_length = 85;  
// Width of holder in front of the phone
holder_side_edge = 4;
// Height of the holder in front of the phone
holder_bottom_edge = 5;
// Cutout in bottom for USB connector
holder_usb_cutout = 40;

/* [General] */
// Thickness of felt or padding between bracket and screen
felt_thickness = 2;
// Length from bottom of holder to top
full_length = 145;

/* [Magins and tweaks] */
// Inside margin between phone and holder
phone_holder_margin = 0.5;
// Thickness of walls
wall_thickness = 2.4;
// Dimensional accuracy
dim_acc = 0.3;

// ===== IMPLEMENTATION ===== //

select_item_part();

module select_item_part() {
    if (item_parts == 0)
        complete();
    else if (item_parts == 1)
        test_holder();
    else if (item_parts == 2)
        test_bracket();
}

module test() {
    
}

module test_holder() {
    // Use this for making a test print of the holder, in order to check phone measurements and fit.
    
    difference() {
        holder();
    
        translate([-20,20,-10])
        linear_extrude(phone_width*2)
        square([phone_thickness*2, holder_length], center = false);

    }    
}

module test_bracket() {
    // Use for test printing the bracket for fit and if needed adjust the full length based on how high or low you want the phone to hang.
    
    bracket(5);
}

module complete() {
    union() {
        main_bracket();
        holder();
    }
}

module holder() {
    
    // This forms the cup at the bottom which holds the mobile phone in place.
    
    // holder outside width
    hw = phone_width + wall_thickness*2+phone_holder_margin*2+dim_acc*2;
    
    // holder outside thickness
    ht = phone_thickness + wall_thickness*2+phone_holder_margin*2+dim_acc*2;
    
    // holder outside length
    hl = holder_length + wall_thickness + phone_holder_margin;

    // holder inside dimensions
    ihw = hw - wall_thickness*2;
    iht = ht - wall_thickness*2;
    ihl = hl - wall_thickness;
        
    difference() {
        // Outside holder with simple beveled edges
        hull() {
            translate([-ht+1,0,0])
            linear_extrude(hw)
            square([ht-1,hl], center = false);

            translate([-ht,1,1])
            linear_extrude(hw-2)
            square([ht,hl-1], center = false);
        }
        
        // Cut out the inside of the holder
        
        translate([-iht-wall_thickness,wall_thickness+dim_acc,wall_thickness])
        linear_extrude(ihw)
        square([iht, ihl], center = false);
        
         // Cut out the front
        translate([-iht-wall_thickness*3,wall_thickness+dim_acc+holder_bottom_edge,wall_thickness+holder_side_edge])
        linear_extrude(ihw-holder_side_edge*2)
        square([iht, ihl-holder_bottom_edge], center = false);

        // Do a slight bevel
        translate([-1,0,0])
        hull() {
            translate([-iht-wall_thickness*3+2,wall_thickness+dim_acc+holder_bottom_edge,wall_thickness+holder_side_edge])
            linear_extrude(ihw-holder_side_edge*2)
            square([2, ihl-holder_bottom_edge], center = false);

            translate([-iht-wall_thickness*3+2,wall_thickness+dim_acc+holder_bottom_edge-1,wall_thickness+holder_side_edge-1])
            linear_extrude(ihw-holder_side_edge*2+2)
            square([1, ihl-holder_bottom_edge+1], center = false);
        }

        // Cut out USB connector
        translate([-ht-wall_thickness,-1,hw/2-holder_usb_cutout/2])
        linear_extrude(holder_usb_cutout)
        square([ht,holder_bottom_edge*2], center = false);
       
    }

     
}

module main_bracket() {    
    // holder outside width
    hw = phone_width + wall_thickness*2+phone_holder_margin*2+dim_acc*2;
    
    bracket(hw);
}

module bracket(hw) {
    // Model the main bracket as a profile of the bracket using a polygon that is then extruded. This forms the back and hook.
    
    linear_extrude(hw)
    polygon(points=[
    [0,0],
    [0,full_length], 
    [10+felt_thickness+dim_acc*2,full_length+1],
    [30+felt_thickness+dim_acc*2,full_length-16],
    [31+felt_thickness+dim_acc*2,full_length-16-9],
    [31+felt_thickness+dim_acc*2+wall_thickness,full_length-16-9],
    [30+felt_thickness+dim_acc*2+wall_thickness,full_length-16+wall_thickness],
    [10+felt_thickness+dim_acc*2+wall_thickness,full_length+1+wall_thickness+dim_acc],
    [-wall_thickness,full_length+wall_thickness],
    [-wall_thickness,0]
    ]);    
}

