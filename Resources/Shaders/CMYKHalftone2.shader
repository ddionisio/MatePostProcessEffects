Shader "Hidden/M8/PostProcessEffects/CMYKHalftone2"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
		#include "Screen.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		//float sst;//0.888
		//float ssq;//0.288
#define sst 0.888
#define ssq 0.288

		float dotSize; //1.48
		float _s; //scale
		float _r; //rotate (radians)
		float4 _clrR; //rotation of each color (c,m,y,k) default: (15,75,0,45) convert these to radians!

		VaryingsDefault Vert(AttributesDefault v)
		{
			VaryingsDefault o;
			o.vertex = float4(v.vertex.xy, 0.0, 1.0);

			float2 uv = TransformTriangleVertexToUV(v.vertex.xy);
			
#if UNITY_UV_STARTS_AT_TOP
			uv = uv * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif

			o.texcoordStereo = TransformStereoScreenSpaceTex(uv, 1.0);

			float4 sp = ComputeScreenPos(o.vertex);
			o.texcoord = _ScreenParams.xy * (sp.xy / sp.w) - _ScreenParams.xy * 0.5;

			return o;
		}

		float4 rgb2cmyki(float3 c)
		{
			float k = max(max(c.r, c.g), c.b);
			return min(float4(c / k, k), 1);
		}

		float4 cmyki2rgb(float4 c)
		{
			return float4(c.rgb * c.a, 1.0);
		}

		float2 px2uv(float2 px)
		{
			return float2(px / _ScreenParams.xy);
		}

		float2 grid(float2 px)
		{
			//float2 m = float2(px.x - _s*floor(px.x/_s), px.y - _s*floor(px.y/_s));
			//return px-m;

			return floor(px / _s) * _s; // alternate
		}

		float4 ss(float4 v)
		{
			return smoothstep(sst - ssq, sst + ssq, v);
		}

		float4 halftone(float2 fc, float2x2 m)
		{
			float2 smp = mul(grid(mul(m, fc)) + 0.5 * _s, m);
			float s = min(length(fc - smp) / (dotSize * 0.5 * _s), 1.0);

			float3 texc = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, px2uv(smp) + float2(0.5, 0.5)).rgb;
			texc = pow(abs(texc), float3(2.2, 2.2, 2.2)); // Gamma decode.

			float4 c = rgb2cmyki(texc);

			return c + s;
		}

		float2x2 rotm(float r)
		{
			float cr = cos(r);
			float sr = sin(r);
			return float2x2(
				cr, -sr,
				sr, cr
				);
		}

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float2 fc = i.texcoord;

			float2x2 mc = rotm(_r + _clrR.x);
			float2x2 mm = rotm(_r + _clrR.y);
			float2x2 my = rotm(_r + _clrR.z);
			float2x2 mk = rotm(_r + _clrR.w);

			//float k = halftone(fc,mk).a;

			return cmyki2rgb(ss(float4(
				halftone(fc,mc).r,
				halftone(fc,mm).g,
				halftone(fc,my).b,
				halftone(fc,mk).a
			)));
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