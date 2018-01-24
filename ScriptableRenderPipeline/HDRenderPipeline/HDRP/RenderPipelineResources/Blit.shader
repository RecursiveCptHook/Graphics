﻿Shader "Hidden/HDRenderPipeline/Blit"
{
    HLSLINCLUDE

        #pragma target 4.5
        #pragma only_renderers d3d11 ps4 xboxone vulkan metal
        #include "CoreRP/ShaderLibrary/Common.hlsl"
        #include "../ShaderVariables.hlsl"

        TEXTURE2D(_BlitTexture);
        SamplerState sampler_PointClamp;
        SamplerState sampler_LinearClamp;

        struct Attributes
        {
            uint vertexID : SV_VertexID;
        };

        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float2 texcoord   : TEXCOORD0;
        };

        Varyings Vert(Attributes input)
        {
            Varyings output;
            output.positionCS = GetFullScreenTriangleVertexPosition(input.vertexID);
            output.texcoord   = GetFullScreenTriangleTexCoord(input.vertexID);
            return output;
        }

        float4 FragNearest(Varyings input) : SV_Target
        {
            return SAMPLE_TEXTURE2D(_BlitTexture, sampler_PointClamp, input.texcoord);
        }

        float4 FragBilinear(Varyings input) : SV_Target
        {
            return SAMPLE_TEXTURE2D(_BlitTexture, sampler_LinearClamp, input.texcoord);
        }

        float4 FragNearestFlipY(Varyings input) : SV_Target
        {
            return SAMPLE_TEXTURE2D(_BlitTexture, sampler_PointClamp, float2(input.texcoord.x, 1.0 - input.texcoord.y));
        }

        float4 FragBilinearFlipY(Varyings input) : SV_Target
        {
            return SAMPLE_TEXTURE2D(_BlitTexture, sampler_LinearClamp, float2(input.texcoord.x, 1.0 - input.texcoord.y));
        }

    ENDHLSL

    SubShader
    {
        // 0: Nearest
        Pass
        {
            ZWrite Off ZTest Always Blend Off Cull Off

            HLSLPROGRAM
                #pragma vertex Vert
                #pragma fragment FragNearest
            ENDHLSL
        }

        // 1: Bilinear
        Pass
        {
            ZWrite Off ZTest Always Blend Off Cull Off

            HLSLPROGRAM
                #pragma vertex Vert
                #pragma fragment FragBilinear
            ENDHLSL
        }

        // 2: Nearest + flipY
        Pass
        {
            ZWrite Off ZTest Always Blend Off Cull Off

            HLSLPROGRAM
                #pragma vertex Vert
                #pragma fragment FragNearestFlipY
            ENDHLSL
        }

        // 3: Bilinear + flipY
        Pass
        {
            ZWrite Off ZTest Always Blend Off Cull Off

            HLSLPROGRAM
                #pragma vertex Vert
                #pragma fragment FragBilinearFlipY
            ENDHLSL
        }
    }

    Fallback Off
}
