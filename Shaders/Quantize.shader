Shader "Hidden/M8/PostProcessEffects/Quantize"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float blend;
		uint levels;

		float quantize(float c)
		{
			uint val = c * 255.0;
			val = (((val * levels + 127) / 255) * 255 + levels / 2) / levels;
			return val / 255.0;
		}

		float4 FragBlend(VaryingsDefault i) : SV_Target
		{
			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			float3 qColor = float3(quantize(color.r), quantize(color.g), quantize(color.b));

			return float4(lerp(color.rgb, qColor, blend), color.a);
		}

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			float3 qColor = float3(quantize(color.r), quantize(color.g), quantize(color.b));

			return float4(qColor, color.a);
		}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment FragBlend
			ENDHLSL
		}

		Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Frag
			ENDHLSL
		}
	}
}