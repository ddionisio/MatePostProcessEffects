Shader "Hidden/M8/PostProcessEffects/Palette16Filter"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float enhance = 1.2;

		float3 color0;
		float3 color1;
		float3 color2;
		float3 color3;
		float3 color4;
		float3 color5;
		float3 color6;
		float3 color7;
		float3 color8;
		float3 color9;
		float3 color10;
		float3 color11;
		float3 color12;
		float3 color13;
		float3 color14;
		float3 color15;

		float dist_sq(float3 a, float3 b) {
			float3 delta = a - b;
			return dot(delta, delta);
		}

		float3 nearest_rgbi(float3 original) {
			float min_dst = 4.0;

			half3 ret = color0;

			half dst = dist_sq(original, color1);
			if (dst < min_dst) { min_dst = dst; ret = color1; }

			dst = dist_sq(original, color2);
			if (dst < min_dst) { min_dst = dst; ret = color2; }

			dst = dist_sq(original, color3);
			if (dst < min_dst) { min_dst = dst; ret = color3; }

			dst = dist_sq(original, color4);
			if (dst < min_dst) { min_dst = dst; ret = color4; }

			dst = dist_sq(original, color5);
			if (dst < min_dst) { min_dst = dst; ret = color5; }

			dst = dist_sq(original, color6);
			if (dst < min_dst) { min_dst = dst; ret = color6; }

			dst = dist_sq(original, color7);
			if (dst < min_dst) { min_dst = dst; ret = color7; }

			dst = dist_sq(original, color8);
			if (dst < min_dst) { min_dst = dst; ret = color8; }

			dst = dist_sq(original, color9);
			if (dst < min_dst) { min_dst = dst; ret = color9; }

			dst = dist_sq(original, color10);
			if (dst < min_dst) { min_dst = dst; ret = color10; }

			dst = dist_sq(original, color11);
			if (dst < min_dst) { min_dst = dst; ret = color11; }

			dst = dist_sq(original, color12);
			if (dst < min_dst) { min_dst = dst; ret = color12; }

			dst = dist_sq(original, color13);
			if (dst < min_dst) { min_dst = dst; ret = color13; }

			dst = dist_sq(original, color14);
			if (dst < min_dst) { min_dst = dst; ret = color14; }

			dst = dist_sq(original, color15);
			if (dst < min_dst) { min_dst = dst; ret = color15; }

			return ret;
		}

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			return float4(nearest_rgbi(color.rgb*enhance), color.a);
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