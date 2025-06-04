Shader "Hidden/M8/PostProcessEffects/Palette4Filter"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float enhance = 1.2;

		float3 color0;
		float3 color1;
		float3 color2;
		float3 color3;

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