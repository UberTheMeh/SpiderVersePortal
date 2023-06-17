Shader "Unlit/SV Portal Ridges Stencil"
{
    Properties
    {
        Color_F7E52541("MainColor", Color) = (0.8113208, 0.1868711, 0, 1)
        Color_B4A6C74E("ShadeColor", Color) = (1, 0.4262067, 0, 1)
        Color_5D2C5349("HighLightColor", Color) = (1, 0.586016, 0, 1)
        [NoScaleOffset]Texture2D_61F2D9B5("EdgeMap", 2D) = "black" {}
        Vector1_F230DAB0("Square Density", Float) = 0.5
        Vector1_B1A12A42("Square Scale", Float) = 10
        Vector1_4B209EBC("Square Width", Float) = 25
        Vector1_6F126DC9("Square Height", Float) = 0.5
        Vector1_9B77EEC8("Square Speed", Float) = 0.25
        Vector1_26892135("Fresnel Power", Float) = 3
        Vector1_B3AF9037("Fresnel Contrast", Float) = 1
        Vector1_B64D012B("Edge Strength", Float) = 1
        Vector1_B007B15D("Edge Contrast", Float) = 1
        Vector1_BD828CF3("Edge Noise Strength", Float) = 1.75
        Vector1_DF37F893("Edge Noise Scale", Float) = 10
        Vector1_791CBC81("Edge Noise Speed", Float) = 0.5
        Vector1_4BEC0E91("Vertical Line Density", Float) = 3
        Vector1_AA308975("Vertical Line Speed", Float) = 1
        Vector1_3D814475("Vertical Line Thickness", Float) = 0.025
        [Enum(Opaque, 0, Cutout, 1, Fade, 2, Transparent, 3, Additive, 4, Multiply, 5)]_Mode("Rendering Mode", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("Source Blend", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("Destination Blend", Float) = 0
        [Enum(Off, 0, On, 1)]_ZWrite("ZWrite", Float) = 1
        [Enum(Off, 0, On, 1)]_AlphaToMask("AlphaToMask", Float) = 0
        [HideInInspector][NonModifiableTextureData][NoScaleOffset]_DFG("Texture2D", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Float) = 2
            [IntRange] _StencilRef("Stencil Reference Value", Range(0,255)) = 0
    }
        SubShader
        {
            Tags
            {
                "RenderPipeline" = ""
                "RenderType" = "Opaque"
                "Queue" = "Geometry+0"
            }

            Pass
            {
                Name "FORWARDBASE"
                Tags
                {
                // LightMode: <None>
            }


                                Stencil{
            Ref[_StencilRef]
            Comp Equal
        }

            // Render State
            Blend[_SrcBlend][_DstBlend]
            Cull[_Cull]
            // ZTest: <None>
            ZWrite[_ZWrite]
    AlphaToMask[_AlphaToMask]
            // ColorMask: <None>


            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            // Pragmas
            #pragma target 4.5
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            // Keywords
            #pragma shader_feature_local _ _ALPHATEST_ON _ALPHAPREMULTIPLY_ON _ALPHAMODULATE_ON
            // GraphKeywords: <None>



            // Defines
            #define ALPHATOCOVERAGE_ON



            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            //#pragma multi_compile_instancing
            #define SHADERPASS_UNLIT

            // Includes
            #include "UnityCG.cginc"
            #include "Packages/com.z3y.shadergraphex/hlsl/ShaderGraph.hlsl"




            // --------------------------------------------------
            // Graph

            // Graph Properties
            float4 Color_F7E52541;
            float4 Color_B4A6C74E;
            float4 Color_5D2C5349;
            float Vector1_F230DAB0;
            float Vector1_B1A12A42;
            float Vector1_4B209EBC;
            float Vector1_6F126DC9;
            float Vector1_9B77EEC8;
            float Vector1_26892135;
            float Vector1_B3AF9037;
            float Vector1_B64D012B;
            float Vector1_B007B15D;
            float Vector1_BD828CF3;
            float Vector1_DF37F893;
            float Vector1_791CBC81;
            float Vector1_4BEC0E91;
            float Vector1_AA308975;
            float Vector1_3D814475;
            TEXTURE2D(Texture2D_61F2D9B5); SAMPLER(samplerTexture2D_61F2D9B5); float4 Texture2D_61F2D9B5_TexelSize;
            SAMPLER(_SampleTexture2D_58E1384F_Sampler_3_Linear_Repeat);

            // Graph Functions

            void Unity_Preview_float4(float4 In, out float4 Out)
            {
                Out = In;
            }

            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }

            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }

            void Unity_Floor_float2(float2 In, out float2 Out)
            {
                Out = floor(In);
            }

            void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A / B;
            }


            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }

            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            {
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }

            void Unity_Contrast_float(float3 In, float Contrast, out float3 Out)
            {
                float midpoint = pow(0.5, 2.2);
                Out = (In - midpoint) * Contrast + midpoint;
            }

            void Unity_Round_float3(float3 In, out float3 Out)
            {
                Out = round(In);
            }

            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }

            void Unity_Blend_LinearDodge_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
            {
                Out = Base + Blend;
                Out = lerp(Base, Out, Opacity);
            }

            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }

            void Unity_Fraction_float(float In, out float Out)
            {
                Out = frac(In);
            }

            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }

            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }

            void Unity_Blend_Lighten_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
            {
                Out = max(Blend, Base);
                Out = lerp(Base, Out, Opacity);
            }

            // Graph Vertex
            // GraphVertex: <None>

            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 WorldSpaceViewDirection;
                float4 uv0;
                float3 TimeParameters;
            };

            struct SurfaceDescription
            {
                float3 Color;
                float Alpha;
                float AlphaClipThreshold;
            };

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_63DF388D_Out_0 = Color_F7E52541;
                float4 _Preview_E1A51733_Out_1;
                Unity_Preview_float4(_Property_63DF388D_Out_0, _Preview_E1A51733_Out_1);
                float _Property_ECD1AE24_Out_0 = Vector1_6F126DC9;
                float _Property_A0EFBE67_Out_0 = Vector1_4B209EBC;
                float2 _Vector2_25A7FFB_Out_0 = float2(_Property_ECD1AE24_Out_0, _Property_A0EFBE67_Out_0);
                float _Property_A0914114_Out_0 = Vector1_9B77EEC8;
                float _Multiply_576A5876_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_A0914114_Out_0, _Multiply_576A5876_Out_2);
                float2 _Vector2_65202BEC_Out_0 = float2(_Multiply_576A5876_Out_2, 2);
                float2 _TilingAndOffset_1EE503FE_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_25A7FFB_Out_0, _Vector2_65202BEC_Out_0, _TilingAndOffset_1EE503FE_Out_3);
                float _Property_99C19EC4_Out_0 = Vector1_B1A12A42;
                float2 _Multiply_B94BD4C8_Out_2;
                Unity_Multiply_float(_TilingAndOffset_1EE503FE_Out_3, (_Property_99C19EC4_Out_0.xx), _Multiply_B94BD4C8_Out_2);
                float2 _Floor_E57705A4_Out_1;
                Unity_Floor_float2(_Multiply_B94BD4C8_Out_2, _Floor_E57705A4_Out_1);
                float2 _Divide_88861108_Out_2;
                Unity_Divide_float2(_Floor_E57705A4_Out_1, (_Property_99C19EC4_Out_0.xx), _Divide_88861108_Out_2);
                float _GradientNoise_99A541BA_Out_2;
                Unity_GradientNoise_float(_Divide_88861108_Out_2, 10.93, _GradientNoise_99A541BA_Out_2);
                float _Property_A17DD48F_Out_0 = Vector1_F230DAB0;
                float3 _Contrast_35486E17_Out_2;
                Unity_Contrast_float((_GradientNoise_99A541BA_Out_2.xxx), _Property_A17DD48F_Out_0, _Contrast_35486E17_Out_2);
                float3 _Round_9AE018BE_Out_1;
                Unity_Round_float3(_Contrast_35486E17_Out_2, _Round_9AE018BE_Out_1);
                float4 _Property_ECC73034_Out_0 = Color_B4A6C74E;
                float3 _Multiply_C29E87FC_Out_2;
                Unity_Multiply_float(_Round_9AE018BE_Out_1, (_Property_ECC73034_Out_0.xyz), _Multiply_C29E87FC_Out_2);
                float _Property_E026FA3B_Out_0 = Vector1_6F126DC9;
                float _Property_B986D917_Out_0 = Vector1_4B209EBC;
                float2 _Vector2_ADCCE502_Out_0 = float2(_Property_E026FA3B_Out_0, _Property_B986D917_Out_0);
                float2 _Multiply_6CCE822A_Out_2;
                Unity_Multiply_float(float2(0.25, 2), _Vector2_ADCCE502_Out_0, _Multiply_6CCE822A_Out_2);
                float _Property_C18FE8CF_Out_0 = Vector1_9B77EEC8;
                float _Multiply_5AE298D5_Out_2;
                Unity_Multiply_float(0.55, _Property_C18FE8CF_Out_0, _Multiply_5AE298D5_Out_2);
                float _Multiply_6931C35C_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Multiply_5AE298D5_Out_2, _Multiply_6931C35C_Out_2);
                float2 _Vector2_ED0868A7_Out_0 = float2(_Multiply_6931C35C_Out_2, 2);
                float2 _TilingAndOffset_7B5787E6_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Multiply_6CCE822A_Out_2, _Vector2_ED0868A7_Out_0, _TilingAndOffset_7B5787E6_Out_3);
                float _Property_D17CEE40_Out_0 = Vector1_B1A12A42;
                float _Multiply_A0F542FD_Out_2;
                Unity_Multiply_float(_Property_D17CEE40_Out_0, 2, _Multiply_A0F542FD_Out_2);
                float2 _Multiply_EE5EF0B1_Out_2;
                Unity_Multiply_float(_TilingAndOffset_7B5787E6_Out_3, (_Multiply_A0F542FD_Out_2.xx), _Multiply_EE5EF0B1_Out_2);
                float2 _Floor_61662B96_Out_1;
                Unity_Floor_float2(_Multiply_EE5EF0B1_Out_2, _Floor_61662B96_Out_1);
                float2 _Divide_CEDCB022_Out_2;
                Unity_Divide_float2(_Floor_61662B96_Out_1, (_Multiply_A0F542FD_Out_2.xx), _Divide_CEDCB022_Out_2);
                float _GradientNoise_DA6751AA_Out_2;
                Unity_GradientNoise_float(_Divide_CEDCB022_Out_2, 10.93, _GradientNoise_DA6751AA_Out_2);
                float _Property_238C579F_Out_0 = Vector1_F230DAB0;
                float3 _Contrast_D62EB77A_Out_2;
                Unity_Contrast_float((_GradientNoise_DA6751AA_Out_2.xxx), _Property_238C579F_Out_0, _Contrast_D62EB77A_Out_2);
                float3 _Round_E3E22093_Out_1;
                Unity_Round_float3(_Contrast_D62EB77A_Out_2, _Round_E3E22093_Out_1);
                float4 _Property_9A521774_Out_0 = Color_F7E52541;
                float3 _Multiply_E910A48F_Out_2;
                Unity_Multiply_float(_Round_E3E22093_Out_1, (_Property_9A521774_Out_0.xyz), _Multiply_E910A48F_Out_2);
                float3 _Blend_46253A6A_Out_2;
                Unity_Blend_LinearDodge_float3(_Multiply_C29E87FC_Out_2, _Multiply_E910A48F_Out_2, _Blend_46253A6A_Out_2, 0.25);
                float3 _Blend_33D5E551_Out_2;
                Unity_Blend_LinearDodge_float3((_Preview_E1A51733_Out_1.xyz), _Blend_46253A6A_Out_2, _Blend_33D5E551_Out_2, 1);
                float4 _Property_EE06DCCD_Out_0 = Color_5D2C5349;
                float4 _UV_89B262DE_Out_0 = IN.uv0;
                float _Split_E2EF2E78_R_1 = _UV_89B262DE_Out_0[0];
                float _Split_E2EF2E78_G_2 = _UV_89B262DE_Out_0[1];
                float _Split_E2EF2E78_B_3 = _UV_89B262DE_Out_0[2];
                float _Split_E2EF2E78_A_4 = _UV_89B262DE_Out_0[3];
                float _Property_BF597272_Out_0 = Vector1_4BEC0E91;
                float _Multiply_4443365C_Out_2;
                Unity_Multiply_float(_Split_E2EF2E78_G_2, _Property_BF597272_Out_0, _Multiply_4443365C_Out_2);
                float _Property_1F1B013E_Out_0 = Vector1_AA308975;
                float _Multiply_602A9CAE_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1F1B013E_Out_0, _Multiply_602A9CAE_Out_2);
                float _Add_BAB46380_Out_2;
                Unity_Add_float(_Multiply_4443365C_Out_2, _Multiply_602A9CAE_Out_2, _Add_BAB46380_Out_2);
                float _Fraction_EB1494E7_Out_1;
                Unity_Fraction_float(_Add_BAB46380_Out_2, _Fraction_EB1494E7_Out_1);
                float _Property_76F4FC12_Out_0 = Vector1_3D814475;
                float _Step_BBEDCF53_Out_2;
                Unity_Step_float(_Fraction_EB1494E7_Out_1, _Property_76F4FC12_Out_0, _Step_BBEDCF53_Out_2);
                float4 _Multiply_42E9AAAB_Out_2;
                Unity_Multiply_float(_Property_EE06DCCD_Out_0, (_Step_BBEDCF53_Out_2.xxxx), _Multiply_42E9AAAB_Out_2);
                float3 _Blend_2BB5B8FD_Out_2;
                Unity_Blend_LinearDodge_float3(_Blend_33D5E551_Out_2, (_Multiply_42E9AAAB_Out_2.xyz), _Blend_2BB5B8FD_Out_2, 1);
                float _Property_97F85CE4_Out_0 = Vector1_26892135;
                float _FresnelEffect_9263A874_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_97F85CE4_Out_0, _FresnelEffect_9263A874_Out_3);
                float4 _Property_39E42253_Out_0 = Color_5D2C5349;
                float4 _Multiply_FD621A00_Out_2;
                Unity_Multiply_float((_FresnelEffect_9263A874_Out_3.xxxx), _Property_39E42253_Out_0, _Multiply_FD621A00_Out_2);
                float _Property_FCEBFEE3_Out_0 = Vector1_B3AF9037;
                float3 _Contrast_3CB0F797_Out_2;
                Unity_Contrast_float((_Multiply_FD621A00_Out_2.xyz), _Property_FCEBFEE3_Out_0, _Contrast_3CB0F797_Out_2);
                float4 _SampleTexture2D_58E1384F_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_61F2D9B5, samplerTexture2D_61F2D9B5, IN.uv0.xy);
                float _SampleTexture2D_58E1384F_R_4 = _SampleTexture2D_58E1384F_RGBA_0.r;
                float _SampleTexture2D_58E1384F_G_5 = _SampleTexture2D_58E1384F_RGBA_0.g;
                float _SampleTexture2D_58E1384F_B_6 = _SampleTexture2D_58E1384F_RGBA_0.b;
                float _SampleTexture2D_58E1384F_A_7 = _SampleTexture2D_58E1384F_RGBA_0.a;
                float _Property_8F3A2635_Out_0 = Vector1_791CBC81;
                float2 _Vector2_2FD56F40_Out_0 = float2(IN.TimeParameters.x, IN.TimeParameters.x);
                float2 _Multiply_640E809F_Out_2;
                Unity_Multiply_float((_Property_8F3A2635_Out_0.xx), _Vector2_2FD56F40_Out_0, _Multiply_640E809F_Out_2);
                float2 _TilingAndOffset_50EAD180_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_640E809F_Out_2, _TilingAndOffset_50EAD180_Out_3);
                float _Property_85708FAC_Out_0 = Vector1_DF37F893;
                float _GradientNoise_5CE05C6C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_50EAD180_Out_3, _Property_85708FAC_Out_0, _GradientNoise_5CE05C6C_Out_2);
                float _Property_F0F3C7C9_Out_0 = Vector1_BD828CF3;
                float3 _Contrast_EC164F24_Out_2;
                Unity_Contrast_float((_GradientNoise_5CE05C6C_Out_2.xxx), _Property_F0F3C7C9_Out_0, _Contrast_EC164F24_Out_2);
                float3 _Multiply_9E013813_Out_2;
                Unity_Multiply_float((_SampleTexture2D_58E1384F_RGBA_0.xyz), _Contrast_EC164F24_Out_2, _Multiply_9E013813_Out_2);
                float _Property_9A3C7E1F_Out_0 = Vector1_B64D012B;
                float3 _Multiply_37524502_Out_2;
                Unity_Multiply_float(_Multiply_9E013813_Out_2, (_Property_9A3C7E1F_Out_0.xxx), _Multiply_37524502_Out_2);
                float _Property_E7BBADE0_Out_0 = Vector1_B007B15D;
                float3 _Contrast_6D522B02_Out_2;
                Unity_Contrast_float(_Multiply_37524502_Out_2, _Property_E7BBADE0_Out_0, _Contrast_6D522B02_Out_2);
                float3 _Multiply_D361FF18_Out_2;
                Unity_Multiply_float((_Property_39E42253_Out_0.xyz), _Contrast_6D522B02_Out_2, _Multiply_D361FF18_Out_2);
                float3 _Blend_E6B7D1E7_Out_2;
                Unity_Blend_Lighten_float3(_Contrast_3CB0F797_Out_2, _Multiply_D361FF18_Out_2, _Blend_E6B7D1E7_Out_2, 1);
                float3 _Blend_81EEDBE3_Out_2;
                Unity_Blend_LinearDodge_float3(_Blend_2BB5B8FD_Out_2, _Blend_E6B7D1E7_Out_2, _Blend_81EEDBE3_Out_2, 1);
                surface.Color = _Blend_81EEDBE3_Out_2;
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }

            // --------------------------------------------------
            // Structs and Packing

            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS;
                float4 texCoord0;
                float3 viewDirectionWS;
                #if defined(FOG_ANY)
                float fogCoord : FOG_COORD;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : SV_InstanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if defined(FOG_ANY)
                float fogCoord : FOG_COORD;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : SV_InstanceID;
                #endif
                float3 interp00 : TEXCOORD0;
                float4 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.normalWS;
                output.interp01.xyzw = input.texCoord0;
                output.interp02.xyz = input.viewDirectionWS;
                #if defined(FOG_ANY)
                output.fogCoord = input.fogCoord;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.normalWS = input.interp00.xyz;
                output.texCoord0 = input.interp01.xyzw;
                output.viewDirectionWS = input.interp02.xyz;
                #if defined(FOG_ANY)
                output.fogCoord = input.fogCoord;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output = (SurfaceDescriptionInputs)0;


                // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);


                output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph


                output.WorldSpaceViewDirection = input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.uv0 = input.texCoord0;
                output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }


            // --------------------------------------------------
            // Main

            #include "Packages/com.z3y.shadergraphex/hlsl/Varyings.hlsl"
            #include "Packages/com.z3y.shadergraphex/hlsl/UnlitPass.hlsl"

            ENDHLSL
        }

        }
            CustomEditor "z3y.ShaderGraphExtended.DefaultInspector"
}
