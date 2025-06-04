Shader "Hidden/M8/PostProcessEffects/CRTSimple"
{
    HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float curvature;
		float vignetteWidth;

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float2 uv = i.texcoord * 2.0f - 1.0f;
            float2 offset = uv.yx / curvature;
            uv = uv + uv * offset * offset;
            uv = uv * 0.5f + 0.5f;

            float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
            if (uv.x <= 0.0f || 1.0f <= uv.x || uv.y <= 0.0f || 1.0f <= uv.y)
                col = 0;

            uv = uv * 2.0f - 1.0f;
            float2 vignette = vignetteWidth / _ScreenParams.xy;
            vignette = smoothstep(0.0f, vignette, 1.0f - abs(uv));
            vignette = saturate(vignette);

            col.g *= (sin(i.texcoord.y * _ScreenParams.y * 2.0f) + 1.0f) * 0.15f + 1.0f;
            col.rb *= (cos(i.texcoord.y * _ScreenParams.y * 2.0f) + 1.0f) * 0.135f + 1.0f; 

            return saturate(col) * vignette.x * vignette.y;
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
