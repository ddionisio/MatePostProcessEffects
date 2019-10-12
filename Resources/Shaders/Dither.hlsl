TEXTURE2D_SAMPLER2D(_DitherTex, sampler_DitherTex);

float ditherStepX; //render.w/dither.w
float ditherStepY; //render.h/dither.h
float ditherAdjustThreshold; //value/255

#define genDither(pos) (SAMPLE_TEXTURE2D(_DitherTex, sampler_DitherTex, (pos)*float2(ditherStepX, ditherStepY)).r + ditherAdjustThreshold)