Shader "Hidden/M8/PostProcessEffects/MonoFilter"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		// 1.0 is the 'proper' value, 1.2 seems to give better results but brighter
		// colors may clip.
		float enhance = 1.2;

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			color.rgb *= enhance;

			float val = floor((0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b) + 0.5);

			return float4(val, val, val, color.a);
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