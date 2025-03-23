shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

// Uniform variable: like our export variables
uniform bool active = false;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 previous_color = texture(TEXTURE, UV); // function accesses a pixel on the texture and looks at it
		//UV = XY positions!
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a); // we just want previous color for those that are clear
	vec4 new_color = previous_color;
	if (active == true) {
		new_color = white_color;
	}
	COLOR = new_color; //red, green, blue, alpha (clearness)
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
