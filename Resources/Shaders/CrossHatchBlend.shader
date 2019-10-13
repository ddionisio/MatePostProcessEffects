Shader "Hidden/M8/PostProcessEffects/CrossHatchBlend"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
		#include "Screen.hlsl"

		struct VaryingsScreen
		{
			float4 vertex : SV_POSITION;
			float2 texcoord : TEXCOORD0;
			float2 texcoordStereo : TEXCOORD1;
#if STEREO_INSTANCING_ENABLED
			uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
#endif

			float2 screenPos : TEXCOORD2;
		};

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
		uniform float4 _MainTex_TexelSize;

		float4 lineColor;
		float4 paperColor;
		float lineDist;//10
		float lineThickness; //1

		float4 lumThreshold; //(1, 0.7, 0.5, 0.3)

		float4 lineStrength; //(1, 0.7, 0.5, 0.3)

		float d; //1

		float lookup(float2 p, float dx, float dy) {
			float2 uv = (p.xy + float2(dx * d, dy * d)) / _ScreenParams.xy;
			float4 c = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
			return c.r * 0.2126 + c.g * 0.7152 + c.b * 0.0722;
		}

		float mod(float x, float y) {
			return x - y * floor(x / y);
		}

		VaryingsScreen Vert(AttributesDefault v)
		{
			VaryingsScreen o;
			o.vertex = float4(v.vertex.xy, 0.0, 1.0);
			o.texcoord = TransformTriangleVertexToUV(v.vertex.xy);

#if UNITY_UV_STARTS_AT_TOP
			o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif

			o.texcoordStereo = TransformStereoScreenSpaceTex(o.texcoord, 1.0);

			float4 sp = ComputeScreenPos(o.vertex);
			o.screenPos = _ScreenParams.xy * (sp.xy / sp.w);

			return o;
		}

		float4 Frag(VaryingsScreen i) : SV_Target
		{
			float4 tc = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			float lum = tc.r * 0.2126 + tc.g * 0.7152 + tc.b * 0.0722;

			float hld = lineDist * 0.5;
			float2 pix = i.screenPos;
			float linePixel = 0;

			if (lum < lumThreshold.x) {
				if (mod(pix.x + pix.y, lineDist) <= lineThickness)
					linePixel = lineStrength.x;
			}
			if (lum < lumThreshold.y) {
				if (mod(pix.x - pix.y, lineDist) <= lineThickness)
					linePixel = lineStrength.y;
			}
			if (lum < lumThreshold.z) {
				if (mod(pix.x + pix.y - hld, lineDist) <= lineThickness)
					linePixel = lineStrength.z;
			}
			if (lum < lumThreshold.w) {
				if (mod(pix.x - pix.y - hld, lineDist) <= lineThickness)
					linePixel = lineStrength.w;
			}

			//sobel edge detect
			float gx = 0;
			gx += -1 * lookup(pix, -1, -1);
			gx += -2 * lookup(pix, -1,  0);
			gx += -1 * lookup(pix, -1,  1);
			gx += 1 * lookup(pix,  1, -1);
			gx += 2 * lookup(pix,  1,  0);
			gx += 1 * lookup(pix,  1,  1);

			float gy = 0;
			gy += -1 * lookup(pix, -1, -1);
			gy += -2 * lookup(pix,  0, -1);
			gy += -1 * lookup(pix,  1, -1);
			gy += 1 * lookup(pix, -1,  1);
			gy += 2 * lookup(pix,  0,  1);
			gy += 1 * lookup(pix,  1,  1);

			float g = gx * gx + gy * gy;
			linePixel = min(linePixel + g, 1);

			float4 lc = lerp(tc, lineColor, lineColor.a);
			float4 pc = lerp(tc, paperColor, paperColor.a);
			float4 clr = lerp(pc, lc, linePixel);

			return clr;
		}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			HLSLPROGRAM
				#pragma vertex Vert
				#pragma fragment Frag
			ENDHLSL
		}
	}
}