Shader "Unlit/SV Portal Ridges Rim Stencil"
{
    Properties
    {
        Color_DA16491E("LineColor", Color) = (1, 0.8338971, 0.0518868, 1)
        Vector1_A315C88B("LineThickness", Float) = 0.05
        Vector1_C6B78A3C("Line Length", Float) = 0.05
        Vector1_C6B48149("Line Speed", Float) = 0.5
        Vector1_51196CB("Line Position", Float) = 0.5
        Color_7DF85989("Glow Color", Color) = (1, 0.2216981, 0.5333199, 1)
        Vector1_4C43A75B("Glow Strength", Float) = 1
        Vector1_1CA3EB90("Glow Noise Scale", Float) = 5
        Vector1_1A71F332("Glow Noise Strength", Float) = 1
        Vector1_8754F99B("Glow Noise Speed", Float) = 0.25
        Vector1_54E7539C("Glow Offset", Float) = 0
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
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_TEXCOORD0
            //#pragma multi_compile_instancing
            #define SHADERPASS_UNLIT

            // Includes
            #include "UnityCG.cginc"
            #include "Packages/com.z3y.shadergraphex/hlsl/ShaderGraph.hlsl"




            // --------------------------------------------------
            // Graph

            // Graph Properties
            float4 Color_DA16491E;
            float Vector1_A315C88B;
            float Vector1_C6B78A3C;
            float Vector1_C6B48149;
            float Vector1_51196CB;
            float4 Color_7DF85989;
            float Vector1_4C43A75B;
            float Vector1_1CA3EB90;
            float Vector1_1A71F332;
            float Vector1_8754F99B;
            float Vector1_54E7539C;

            // Graph Functions

            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }

            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
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

            void Unity_OneMinus_float3(float3 In, out float3 Out)
            {
                Out = 1 - In;
            }

            void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
            {
                Out = clamp(In, Min, Max);
            }

            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
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

            void Unity_Blend_LinearDodge_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
            {
                Out = Base + Blend;
                Out = lerp(Base, Out, Opacity);
            }

            void Unity_Clamp_float(float In, float Min, float Max, out float Out)
            {
                Out = clamp(In, Min, Max);
            }

            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }

            // Graph Vertex
            // GraphVertex: <None>

            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 ViewSpacePosition;
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
                float _Property_9A554F05_Out_0 = Vector1_54E7539C;
                float2 _Vector2_FAD2D6C4_Out_0 = float2(0, _Property_9A554F05_Out_0);
                float2 _TilingAndOffset_B8DFE8E_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_FAD2D6C4_Out_0, _TilingAndOffset_B8DFE8E_Out_3);
                float _Split_D77B32DA_R_1 = _TilingAndOffset_B8DFE8E_Out_3[0];
                float _Split_D77B32DA_G_2 = _TilingAndOffset_B8DFE8E_Out_3[1];
                float _Split_D77B32DA_B_3 = 0;
                float _Split_D77B32DA_A_4 = 0;
                float _Property_C146D2E8_Out_0 = Vector1_4C43A75B;
                float _Multiply_14CA770E_Out_2;
                Unity_Multiply_float(_Split_D77B32DA_G_2, _Property_C146D2E8_Out_0, _Multiply_14CA770E_Out_2);
                float2 _Vector2_CE5E143_Out_0 = float2(IN.TimeParameters.x, IN.TimeParameters.x);
                float _Property_AB6016D_Out_0 = Vector1_8754F99B;
                float2 _Multiply_3BE79057_Out_2;
                Unity_Multiply_float(_Vector2_CE5E143_Out_0, (_Property_AB6016D_Out_0.xx), _Multiply_3BE79057_Out_2);
                float2 _TilingAndOffset_94498E36_Out_3;
                Unity_TilingAndOffset_float((IN.ViewSpacePosition.xy), float2 (1, 1), _Multiply_3BE79057_Out_2, _TilingAndOffset_94498E36_Out_3);
                float _Property_8BC47132_Out_0 = Vector1_1CA3EB90;
                float _GradientNoise_353EDAE4_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_94498E36_Out_3, _Property_8BC47132_Out_0, _GradientNoise_353EDAE4_Out_2);
                float _Property_C134277D_Out_0 = Vector1_1A71F332;
                float3 _Contrast_BB08AB3F_Out_2;
                Unity_Contrast_float((_GradientNoise_353EDAE4_Out_2.xxx), _Property_C134277D_Out_0, _Contrast_BB08AB3F_Out_2);
                float3 _OneMinus_776E553C_Out_1;
                Unity_OneMinus_float3(_Contrast_BB08AB3F_Out_2, _OneMinus_776E553C_Out_1);
                float3 _Clamp_9B1E268D_Out_3;
                Unity_Clamp_float3(_OneMinus_776E553C_Out_1, float3(0, 0, 0), float3(1, 1, 1), _Clamp_9B1E268D_Out_3);
                float3 _Multiply_6348F6BF_Out_2;
                Unity_Multiply_float((_Multiply_14CA770E_Out_2.xxx), _Clamp_9B1E268D_Out_3, _Multiply_6348F6BF_Out_2);
                float4 _Property_C0E2DE74_Out_0 = Color_7DF85989;
                float3 _Multiply_D38B1000_Out_2;
                Unity_Multiply_float(_Multiply_6348F6BF_Out_2, (_Property_C0E2DE74_Out_0.xyz), _Multiply_D38B1000_Out_2);
                float _Property_82C98D9C_Out_0 = Vector1_C6B48149;
                float _Multiply_55B906F_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_82C98D9C_Out_0, _Multiply_55B906F_Out_2);
                float _Property_743B7E49_Out_0 = Vector1_51196CB;
                float2 _Vector2_A7DA410F_Out_0 = float2(_Multiply_55B906F_Out_2, _Property_743B7E49_Out_0);
                float2 _TilingAndOffset_542302CC_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_A7DA410F_Out_0, _TilingAndOffset_542302CC_Out_3);
                float _Split_CE916FF2_R_1 = _TilingAndOffset_542302CC_Out_3[0];
                float _Split_CE916FF2_G_2 = _TilingAndOffset_542302CC_Out_3[1];
                float _Split_CE916FF2_B_3 = 0;
                float _Split_CE916FF2_A_4 = 0;
                float _Fraction_C47E33EE_Out_1;
                Unity_Fraction_float(_Split_CE916FF2_R_1, _Fraction_C47E33EE_Out_1);
                float _Property_98C21F99_Out_0 = Vector1_C6B78A3C;
                float _Step_5C9578CD_Out_2;
                Unity_Step_float(_Fraction_C47E33EE_Out_1, _Property_98C21F99_Out_0, _Step_5C9578CD_Out_2);
                float _Fraction_B32ADE84_Out_1;
                Unity_Fraction_float(_Split_CE916FF2_G_2, _Fraction_B32ADE84_Out_1);
                float _Property_7D823A38_Out_0 = Vector1_A315C88B;
                float _Step_E78F3A_Out_2;
                Unity_Step_float(_Fraction_B32ADE84_Out_1, _Property_7D823A38_Out_0, _Step_E78F3A_Out_2);
                float _Multiply_A8EE6DE6_Out_2;
                Unity_Multiply_float(_Step_5C9578CD_Out_2, _Step_E78F3A_Out_2, _Multiply_A8EE6DE6_Out_2);
                float4 _Property_52F59711_Out_0 = Color_DA16491E;
                float4 _Multiply_B13FCCCC_Out_2;
                Unity_Multiply_float((_Multiply_A8EE6DE6_Out_2.xxxx), _Property_52F59711_Out_0, _Multiply_B13FCCCC_Out_2);
                float3 _Blend_AD22E714_Out_2;
                Unity_Blend_LinearDodge_float3(_Multiply_D38B1000_Out_2, (_Multiply_B13FCCCC_Out_2.xyz), _Blend_AD22E714_Out_2, 1);
                float _Clamp_C4E0CEE0_Out_3;
                Unity_Clamp_float(0, _Multiply_A8EE6DE6_Out_2, 1, _Clamp_C4E0CEE0_Out_3);
                float3 _Add_EC28322A_Out_2;
                Unity_Add_float3((_Clamp_C4E0CEE0_Out_3.xxx), _Multiply_6348F6BF_Out_2, _Add_EC28322A_Out_2);
                float3 _Clamp_3B6E9F9C_Out_3;
                Unity_Clamp_float3(_Add_EC28322A_Out_2, float3(0, 0, 0), float3(1, 1, 1), _Clamp_3B6E9F9C_Out_3);
                surface.Color = _Blend_AD22E714_Out_2;
                surface.Alpha = (_Clamp_3B6E9F9C_Out_3).x;
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
                float3 positionWS;
                float4 texCoord0;
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
                output.interp00.xyz = input.positionWS;
                output.interp01.xyzw = input.texCoord0;
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
                output.positionWS = input.interp00.xyz;
                output.texCoord0 = input.interp01.xyzw;
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






                output.ViewSpacePosition = TransformWorldToView(input.positionWS);
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

        Pass
        {
            Name "SHADOWCASTER"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

                // Render State
                // Blending: <None>
                Cull[_Cull]
                ZTest LEqual
                ZWrite On
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
                #pragma multi_compile_instancing
                #pragma multi_compile_shadowcaster

                // Keywords
                #pragma shader_feature_local _ _ALPHATEST_ON _ALPHAPREMULTIPLY_ON _ALPHAFADE_ON
                // GraphKeywords: <None>



                // Defines



                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_POSITION_WS 
                #define VARYINGS_NEED_TEXCOORD0
                //#pragma multi_compile_instancing
                #define SHADERPASS_SHADOWCASTER

                // Includes
                #include "UnityCG.cginc"
                #include "Packages/com.z3y.shadergraphex/hlsl/ShaderGraph.hlsl"




                // --------------------------------------------------
                // Graph

                // Graph Properties
                float4 Color_DA16491E;
                float Vector1_A315C88B;
                float Vector1_C6B78A3C;
                float Vector1_C6B48149;
                float Vector1_51196CB;
                float4 Color_7DF85989;
                float Vector1_4C43A75B;
                float Vector1_1CA3EB90;
                float Vector1_1A71F332;
                float Vector1_8754F99B;
                float Vector1_54E7539C;

                // Graph Functions

                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }

                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }

                void Unity_Fraction_float(float In, out float Out)
                {
                    Out = frac(In);
                }

                void Unity_Step_float(float Edge, float In, out float Out)
                {
                    Out = step(Edge, In);
                }

                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }

                void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
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

                void Unity_OneMinus_float3(float3 In, out float3 Out)
                {
                    Out = 1 - In;
                }

                void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
                {
                    Out = clamp(In, Min, Max);
                }

                void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }

                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }

                // Graph Vertex
                // GraphVertex: <None>

                // Graph Pixel
                struct SurfaceDescriptionInputs
                {
                    float3 ViewSpacePosition;
                    float4 uv0;
                    float3 TimeParameters;
                };

                struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };

                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_82C98D9C_Out_0 = Vector1_C6B48149;
                    float _Multiply_55B906F_Out_2;
                    Unity_Multiply_float(IN.TimeParameters.x, _Property_82C98D9C_Out_0, _Multiply_55B906F_Out_2);
                    float _Property_743B7E49_Out_0 = Vector1_51196CB;
                    float2 _Vector2_A7DA410F_Out_0 = float2(_Multiply_55B906F_Out_2, _Property_743B7E49_Out_0);
                    float2 _TilingAndOffset_542302CC_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_A7DA410F_Out_0, _TilingAndOffset_542302CC_Out_3);
                    float _Split_CE916FF2_R_1 = _TilingAndOffset_542302CC_Out_3[0];
                    float _Split_CE916FF2_G_2 = _TilingAndOffset_542302CC_Out_3[1];
                    float _Split_CE916FF2_B_3 = 0;
                    float _Split_CE916FF2_A_4 = 0;
                    float _Fraction_C47E33EE_Out_1;
                    Unity_Fraction_float(_Split_CE916FF2_R_1, _Fraction_C47E33EE_Out_1);
                    float _Property_98C21F99_Out_0 = Vector1_C6B78A3C;
                    float _Step_5C9578CD_Out_2;
                    Unity_Step_float(_Fraction_C47E33EE_Out_1, _Property_98C21F99_Out_0, _Step_5C9578CD_Out_2);
                    float _Fraction_B32ADE84_Out_1;
                    Unity_Fraction_float(_Split_CE916FF2_G_2, _Fraction_B32ADE84_Out_1);
                    float _Property_7D823A38_Out_0 = Vector1_A315C88B;
                    float _Step_E78F3A_Out_2;
                    Unity_Step_float(_Fraction_B32ADE84_Out_1, _Property_7D823A38_Out_0, _Step_E78F3A_Out_2);
                    float _Multiply_A8EE6DE6_Out_2;
                    Unity_Multiply_float(_Step_5C9578CD_Out_2, _Step_E78F3A_Out_2, _Multiply_A8EE6DE6_Out_2);
                    float _Clamp_C4E0CEE0_Out_3;
                    Unity_Clamp_float(0, _Multiply_A8EE6DE6_Out_2, 1, _Clamp_C4E0CEE0_Out_3);
                    float _Property_9A554F05_Out_0 = Vector1_54E7539C;
                    float2 _Vector2_FAD2D6C4_Out_0 = float2(0, _Property_9A554F05_Out_0);
                    float2 _TilingAndOffset_B8DFE8E_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_FAD2D6C4_Out_0, _TilingAndOffset_B8DFE8E_Out_3);
                    float _Split_D77B32DA_R_1 = _TilingAndOffset_B8DFE8E_Out_3[0];
                    float _Split_D77B32DA_G_2 = _TilingAndOffset_B8DFE8E_Out_3[1];
                    float _Split_D77B32DA_B_3 = 0;
                    float _Split_D77B32DA_A_4 = 0;
                    float _Property_C146D2E8_Out_0 = Vector1_4C43A75B;
                    float _Multiply_14CA770E_Out_2;
                    Unity_Multiply_float(_Split_D77B32DA_G_2, _Property_C146D2E8_Out_0, _Multiply_14CA770E_Out_2);
                    float2 _Vector2_CE5E143_Out_0 = float2(IN.TimeParameters.x, IN.TimeParameters.x);
                    float _Property_AB6016D_Out_0 = Vector1_8754F99B;
                    float2 _Multiply_3BE79057_Out_2;
                    Unity_Multiply_float(_Vector2_CE5E143_Out_0, (_Property_AB6016D_Out_0.xx), _Multiply_3BE79057_Out_2);
                    float2 _TilingAndOffset_94498E36_Out_3;
                    Unity_TilingAndOffset_float((IN.ViewSpacePosition.xy), float2 (1, 1), _Multiply_3BE79057_Out_2, _TilingAndOffset_94498E36_Out_3);
                    float _Property_8BC47132_Out_0 = Vector1_1CA3EB90;
                    float _GradientNoise_353EDAE4_Out_2;
                    Unity_GradientNoise_float(_TilingAndOffset_94498E36_Out_3, _Property_8BC47132_Out_0, _GradientNoise_353EDAE4_Out_2);
                    float _Property_C134277D_Out_0 = Vector1_1A71F332;
                    float3 _Contrast_BB08AB3F_Out_2;
                    Unity_Contrast_float((_GradientNoise_353EDAE4_Out_2.xxx), _Property_C134277D_Out_0, _Contrast_BB08AB3F_Out_2);
                    float3 _OneMinus_776E553C_Out_1;
                    Unity_OneMinus_float3(_Contrast_BB08AB3F_Out_2, _OneMinus_776E553C_Out_1);
                    float3 _Clamp_9B1E268D_Out_3;
                    Unity_Clamp_float3(_OneMinus_776E553C_Out_1, float3(0, 0, 0), float3(1, 1, 1), _Clamp_9B1E268D_Out_3);
                    float3 _Multiply_6348F6BF_Out_2;
                    Unity_Multiply_float((_Multiply_14CA770E_Out_2.xxx), _Clamp_9B1E268D_Out_3, _Multiply_6348F6BF_Out_2);
                    float3 _Add_EC28322A_Out_2;
                    Unity_Add_float3((_Clamp_C4E0CEE0_Out_3.xxx), _Multiply_6348F6BF_Out_2, _Add_EC28322A_Out_2);
                    float3 _Clamp_3B6E9F9C_Out_3;
                    Unity_Clamp_float3(_Add_EC28322A_Out_2, float3(0, 0, 0), float3(1, 1, 1), _Clamp_3B6E9F9C_Out_3);
                    surface.Alpha = (_Clamp_3B6E9F9C_Out_3).x;
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
                    float3 positionWS;
                    float4 texCoord0;
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
                    output.interp00.xyz = input.positionWS;
                    output.interp01.xyzw = input.texCoord0;
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
                    output.positionWS = input.interp00.xyz;
                    output.texCoord0 = input.interp01.xyzw;
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






                    output.ViewSpacePosition = TransformWorldToView(input.positionWS);
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
                #include "Packages/com.z3y.shadergraphex/hlsl/ShadowCasterPass.hlsl"

                ENDHLSL
            }

        }
            CustomEditor "z3y.ShaderGraphExtended.DefaultInspector"
}
