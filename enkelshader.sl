surface enkelshader(
	color blue = ( 0.0, 0.0, 0.5); 			// Blue color
	color yellow = ( 0.95, 0.9, 0.0); 		// Yellow color
	color white = ( 1.0, 1.0, 1.0); 		// White color
	float frequency = (4.0);				// Frequency of meridians (stripes) in the sphere
	color diffuseLight = (0.9, 0.9, 0.9);	// Color defining the light being shed on the object
	float roughness = (0.04);				// The level of irregularity
	float bumpdepth = (0.2);				// The depth of the texture bumps
	)
{
	float fx = mod((s * frequency), 1.0);	// Iterate frequencies through the meridians (u)
	float alignedMeridian = mod((s * frequency + 0.125), 1.0);		//
	
	// Smoothly transition from 0.25 units until 0.5 units at each frequency
	// First value indicates the end of solid color (from 0.0)
	// Second value indicates end of smoothed color, i.e. when that color ceases
	float f1 = smoothstep(0.25, 0.5, fx);
	float f2 = smoothstep(0.75, 1.0, fx);
	float f3 = smoothstep(0.05, 0.12, t);
	
	
	point pp = P;
	pp +=  step(0.5, alignedMeridian)*(noise(P * frequency)* N * bumpdepth);
	N = calculatenormal(pp);
	
	// Calculate the normal of the shape
	normal normalValue = normalize(N);
	
	// Create a color mix with white and another mix, switching/blending between the interval of the third parameter
	// Second mix switches between yellow and blue, smoothly blending them in the f1 and f2 smoothstep intervals
	color c = mix (white, mix(yellow, blue, f1-f2), f3);
	
	// Diffuse the color by multiplying it with a diffuse function
	color diffusedColor = c * diffuse(normalValue);
	
	// Add diffused light to the object
	color diffuseLitColor = diffusedColor * diffuseLight;
	
	// Render
	Ci = diffuseLitColor;
	Oi = Os;
}