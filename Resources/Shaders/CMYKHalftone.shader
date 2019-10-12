Shader "Hidden/M8/PostProcessEffects/CMYKHalftone"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
		uniform float4 _MainTex_TexelSize;

		float frequency;
		float4 rot;

		float uScale;
		float uYrot;

		float aastep(float threshold, float value) {
			float afwidth = frequency * (1.0 / 200.0) / uScale / cos(uYrot);
			return smoothstep(threshold - afwidth, threshold + afwidth, value);
		}

		// Explicit bilinear texture lookup to circumvent bad hardware precision.
		// The extra arguments specify the dimension of the texture. (GLSL 1.30
		// introduced textureSize() to get that information from the sampler.)
		// 'dims' is the width and height of the texture, 'one' is 1.0/dims.
		// (Precomputing 'one' saves two divisions for each lookup.)
		float4 texture2D_bilinear(float2 st) {
			float2 dims = _MainTex_TexelSize.zw;
			float2 one = _MainTex_TexelSize.xy;

			float2 uv = st * dims;
			float2 uv00 = floor(uv - float2(0.5, 0.5)); // Lower left corner of lower left texel
			float2 uvlerp = uv - uv00 - float2(0.5, 0.5); // Texel-local lerp blends [0,1]
			float2 st00 = (uv00 + float(0.5)) * one;
			float4 texel00 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, st00);
			float4 texel10 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, st00 + float2(one.x, 0.0));
			float4 texel01 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, st00 + float2(0.0, one.y));
			float4 texel11 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, st00 + one);
			float4 texel0 = lerp(texel00, texel01, uvlerp.y);
			float4 texel1 = lerp(texel10, texel11, uvlerp.y);
			return lerp(texel0, texel1, uvlerp.x);
		}

		float2x2 rotMtx(float r) {
			float c = cos(r);
			float s = sin(r);
			return float2x2(c, -s, s, c);
		}

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float2 st = i.texcoord;

			float3 texcolor = texture2D_bilinear(st).xyz;

			//add a bit of noise, set to 0 for clean
			float n = GradientNoise(i.texcoord); //0

			float3 black = float3(0,0,0);

			//rgb-cmyk
			float4 cmyk;
			cmyk.xyz = 1.0 - texcolor;
			cmyk.w = min(cmyk.x, min(cmyk.y, cmyk.z)); // Create K
			cmyk.xyz -= cmyk.w; // Subtract K equivalent from CMY


			// Distance to nearest point in a grid of
			// (frequency x frequency) points over the unit square
			float2 Kst = frequency * mul(rotMtx(rot.w), st);
			float2 Kuv = 2.0 * frac(Kst) - 1.0;
			float k = aastep(0.0, sqrt(cmyk.w) - length(Kuv) + n);
			float2 Cst = frequency * mul(rotMtx(rot.x), st);
			float2 Cuv = 2.0 * frac(Cst) - 1.0;
			float c = aastep(0.0, sqrt(cmyk.x) - length(Cuv) + n);
			float2 Mst = frequency * mul(rotMtx(rot.y), st);
			float2 Muv = 2.0 * frac(Mst) - 1.0;
			float m = aastep(0.0, sqrt(cmyk.y) - length(Muv) + n);
			float2 Yst = frequency * mul(rotMtx(rot.z), st);
			float2 Yuv = 2.0 * frac(Yst) - 1.0;
			float y = aastep(0.0, sqrt(cmyk.z) - length(Yuv) + n);

			float3 rgbscreen = 1.0 - 0.9 * float3(c,m,y) + n;
			rgbscreen = lerp(rgbscreen, black, 0.85 * k + 0.3 * n);

			float afwidth = frequency * (1.0 / 200.0) / uScale / cos(uYrot);

			float blend = smoothstep(0.7, 1.4, afwidth);

			return half4(lerp(rgbscreen, texcolor, blend), SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, st).a);

			//float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			//return color;
		}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Frag
			ENDHLSL
		}
	}
}