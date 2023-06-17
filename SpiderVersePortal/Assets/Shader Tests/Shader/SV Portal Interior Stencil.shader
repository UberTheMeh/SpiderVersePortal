Shader "Unlit/SV Portal Interior Stencil"
{
    Properties
    {
        Color_D2AC8B08("Base Color", Color) = (1, 0.9401177, 0.1556604, 1)
        Color_FC461CB8("EdgeColor", Color) = (1, 0, 0.6, 1)
        Vector1_36C374ED("Edge Power", Float) = 1
        Color_EB1EAECF("LineColor", Color) = (1, 0.8678795, 0.08962262, 1)
        Vector1_11714EEB("Line Thickness", Float) = 0.25
        Vector1_3A342253("LineSpeed", Float) = 0.5
        Vector1_A5C0BA1F("Line Density", Float) = 10
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
            #define VARYINGS_NEED_TEXCOORD0
            //#pragma multi_compile_instancing
            #define SHADERPASS_UNLIT

            // Includes
            #include "UnityCG.cginc"
            #include "Packages/com.z3y.shadergraphex/hlsl/ShaderGraph.hlsl"




            // --------------------------------------------------
            // Graph

            // Graph Properties
            float4 Color_D2AC8B08;
            float4 Color_FC461CB8;
            float Vector1_36C374ED;
            float4 Color_EB1EAECF;
            float Vector1_11714EEB;
            float Vector1_3A342253;
            float Vector1_A5C0BA1F;

            // Graph Functions

            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }

            void Unity_Blend_LinearDodge_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
            {
                Out = Base + Blend;
                Out = lerp(Base, Out, Opacity);
            }

            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
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

            // Graph Vertex
            // GraphVertex: <None>

            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
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
                float4 _Property_E863B76_Out_0 = Color_FC461CB8;
                float4 _UV_7A86CA57_Out_0 = IN.uv0;
                float _Split_CD240D2B_R_1 = _UV_7A86CA57_Out_0[0];
                float _Split_CD240D2B_G_2 = _UV_7A86CA57_Out_0[1];
                float _Split_CD240D2B_B_3 = _UV_7A86CA57_Out_0[2];
                float _Split_CD240D2B_A_4 = _UV_7A86CA57_Out_0[3];
                float4 _Multiply_208B3AA4_Out_2;
                Unity_Multiply_float(_Property_E863B76_Out_0, (_Split_CD240D2B_G_2.xxxx), _Multiply_208B3AA4_Out_2);
                float4 _Property_EDD086E3_Out_0 = Color_D2AC8B08;
                float _OneMinus_7F68D5D4_Out_1;
                Unity_OneMinus_float(_Split_CD240D2B_G_2, _OneMinus_7F68D5D4_Out_1);
                float4 _Multiply_591775A5_Out_2;
                Unity_Multiply_float(_Property_EDD086E3_Out_0, (_OneMinus_7F68D5D4_Out_1.xxxx), _Multiply_591775A5_Out_2);
                float _Property_1623F850_Out_0 = Vector1_36C374ED;
                float4 _Blend_91569C24_Out_2;
                Unity_Blend_LinearDodge_float4(_Multiply_208B3AA4_Out_2, _Multiply_591775A5_Out_2, _Blend_91569C24_Out_2, _Property_1623F850_Out_0);
                float4 _Property_5A4CAB2B_Out_0 = Color_EB1EAECF;
                float4 _UV_E0024341_Out_0 = IN.uv0;
                float _Split_BDFDC649_R_1 = _UV_E0024341_Out_0[0];
                float _Split_BDFDC649_G_2 = _UV_E0024341_Out_0[1];
                float _Split_BDFDC649_B_3 = _UV_E0024341_Out_0[2];
                float _Split_BDFDC649_A_4 = _UV_E0024341_Out_0[3];
                float _Property_282F69C2_Out_0 = Vector1_A5C0BA1F;
                float _Multiply_BAE9D8AE_Out_2;
                Unity_Multiply_float(_Split_BDFDC649_G_2, _Property_282F69C2_Out_0, _Multiply_BAE9D8AE_Out_2);
                float _Property_E4E81840_Out_0 = Vector1_3A342253;
                float _Multiply_BC0A3ACC_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_E4E81840_Out_0, _Multiply_BC0A3ACC_Out_2);
                float _OneMinus_D2A571A0_Out_1;
                Unity_OneMinus_float(_Multiply_BC0A3ACC_Out_2, _OneMinus_D2A571A0_Out_1);
                float _Add_3BBEDF0C_Out_2;
                Unity_Add_float(_Multiply_BAE9D8AE_Out_2, _OneMinus_D2A571A0_Out_1, _Add_3BBEDF0C_Out_2);
                float _Fraction_F7A51244_Out_1;
                Unity_Fraction_float(_Add_3BBEDF0C_Out_2, _Fraction_F7A51244_Out_1);
                float _Property_37C80D26_Out_0 = Vector1_11714EEB;
                float _Step_2060104B_Out_2;
                Unity_Step_float(_Fraction_F7A51244_Out_1, _Property_37C80D26_Out_0, _Step_2060104B_Out_2);
                float4 _Multiply_F4610C91_Out_2;
                Unity_Multiply_float(_Property_5A4CAB2B_Out_0, (_Step_2060104B_Out_2.xxxx), _Multiply_F4610C91_Out_2);
                float4 _Multiply_496C3AE8_Out_2;
                Unity_Multiply_float(_Blend_91569C24_Out_2, _Multiply_F4610C91_Out_2, _Multiply_496C3AE8_Out_2);
                float4 _Blend_966A9D52_Out_2;
                Unity_Blend_LinearDodge_float4(_Blend_91569C24_Out_2, _Multiply_496C3AE8_Out_2, _Blend_966A9D52_Out_2, 1);
                surface.Color = (_Blend_966A9D52_Out_2.xyz);
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
                float4 interp00 : TEXCOORD0;
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
                output.interp00.xyzw = input.texCoord0;
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
                output.texCoord0 = input.interp00.xyzw;
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
                //#pragma multi_compile_instancing
                #define SHADERPASS_SHADOWCASTER

                // Includes
                #include "UnityCG.cginc"
                #include "Packages/com.z3y.shadergraphex/hlsl/ShaderGraph.hlsl"




                // --------------------------------------------------
                // Graph

                // Graph Properties
                float4 Color_D2AC8B08;
                float4 Color_FC461CB8;
                float Vector1_36C374ED;
                float4 Color_EB1EAECF;
                float Vector1_11714EEB;
                float Vector1_3A342253;
                float Vector1_A5C0BA1F;

                // Graph Functions
                // GraphFunctions: <None>

                // Graph Vertex
                // GraphVertex: <None>

                // Graph Pixel
                struct SurfaceDescriptionInputs
                {
                };

                struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };

                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
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
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };

                // Generated Type: Varyings
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
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
