/**************************
***** Compiler Parameters *****
***************************
@P EffectName: StrideForwardShadingEffect
@P   - Material.PixelStageSurfaceShaders: mixin MaterialSurfaceArray [{layers = [mixin MaterialSurfaceDiffuse [{diffuseMap = mixin Float4ToColor [{Value = mixin DoFloat4 [{Before = mixin ComputeOrder [{Computes = [mixin AssignVarFloat4<Input_0> [{Value = InputFloat4<ShaderFX.InputValueFloat4,PerMaterial>}]]}]}, {Value = GetVarFloat4<Input_0>}]}]}], mixin MaterialSurfaceGlossinessMap<true> [{glossinessMap = mixin FloatToScalar [{Value = mixin DoFloat [{Before = mixin ComputeOrder [{Computes = [mixin AssignVarFloat<Input_1> [{Value = InputFloat<ShaderFX.InputValueFloat,PerMaterial>}]]}]}, {Value = GetVarFloat<Input_1>}]}]}], mixin MaterialSurfaceMetalness [{metalnessMap = mixin FloatToScalar [{Value = mixin DoFloat [{Before = mixin ComputeOrder [{Computes = [mixin AssignVarFloat<Input_2> [{Value = InputFloat<ShaderFX.InputValueFloat.i1,PerMaterial>}]]}]}, {Value = GetVarFloat<Input_2>}]}]}], mixin MaterialSurfaceLightingAndShading [{surfaces = [MaterialSurfaceShadingDiffuseLambert<false>, mixin MaterialSurfaceShadingSpecularMicrofacet [{environmentFunction = MaterialSpecularMicrofacetEnvironmentGGXLUT}, {fresnelFunction = MaterialSpecularMicrofacetFresnelSchlick}, {geometricShadowingFunction = MaterialSpecularMicrofacetVisibilitySmithSchlickGGX}, {normalDistributionFunction = MaterialSpecularMicrofacetNormalDistributionGGX}]]}]]}]
@P Material.PixelStageStreamInitializer: mixin MaterialStream, MaterialPixelShadingStream
@P Lighting.DirectLightGroups: mixin LightDirectionalGroup<2>, ShadowMapReceiverDirectional<4,2,true,true,false,false>, ShadowMapFilterPcf<PerView.Lighting,5>, LightClusteredPointGroup, LightClusteredSpotGroup
@P Lighting.EnvironmentLights: LightSimpleAmbient, EnvironmentLight
@P StrideEffectBase.RenderTargetExtensions: mixin [{ShadingColor1 = GBufferOutputSubsurfaceScatteringMaterialIndex}]
***************************
****  ConstantBuffers  ****
***************************
cbuffer PerDraw [Size: 432]
@C    World_id32 => Transformation.World
@C    WorldInverse_id33 => Transformation.WorldInverse
@C    WorldInverseTranspose_id34 => Transformation.WorldInverseTranspose
@C    WorldView_id35 => Transformation.WorldView
@C    WorldViewInverse_id36 => Transformation.WorldViewInverse
@C    WorldViewProjection_id37 => Transformation.WorldViewProjection
@C    WorldScale_id38 => Transformation.WorldScale
@C    EyeMS_id39 => Transformation.EyeMS
@C    MaterialIndex_id83 => GBufferOutputSubsurfaceScatteringMaterialIndex.MaterialIndex
cbuffer PerMaterial [Size: 32]
@C    InputValue_id184 => ShaderFX.InputValueFloat4
@C    InputValue_id192 => ShaderFX.InputValueFloat
@C    InputValue_id201 => ShaderFX.InputValueFloat.i1
cbuffer PerView [Size: 2400]
@C    View_id25 => Transformation.View
@C    ViewInverse_id26 => Transformation.ViewInverse
@C    Projection_id27 => Transformation.Projection
@C    ProjectionInverse_id28 => Transformation.ProjectionInverse
@C    ViewProjection_id29 => Transformation.ViewProjection
@C    ProjScreenRay_id30 => Transformation.ProjScreenRay
@C    Eye_id31 => Transformation.Eye
@C    NearClipPlane_id168 => Camera.NearClipPlane
@C    FarClipPlane_id169 => Camera.FarClipPlane
@C    ZProjection_id170 => Camera.ZProjection
@C    ViewSize_id171 => Camera.ViewSize
@C    AspectRatio_id172 => Camera.AspectRatio
@C    _padding_PerView_Default => _padding_PerView_Default
@C    LightCount_id86 => DirectLightGroupPerView.LightCount.directLightGroups[0]
@C    Lights_id88 => LightDirectionalGroup.Lights.directLightGroups[0]
@C    ShadowMapTextureSize_id90 => ShadowMap.TextureSize.directLightGroups[0]
@C    ShadowMapTextureTexelSize_id91 => ShadowMap.TextureTexelSize.directLightGroups[0]
@C    WorldToShadowCascadeUV_id153 => ShadowMapReceiverBase.WorldToShadowCascadeUV.directLightGroups[0]
@C    InverseWorldToShadowCascadeUV_id154 => ShadowMapReceiverBase.InverseWorldToShadowCascadeUV.directLightGroups[0]
@C    ViewMatrices_id155 => ShadowMapReceiverBase.ViewMatrices.directLightGroups[0]
@C    DepthRanges_id156 => ShadowMapReceiverBase.DepthRanges.directLightGroups[0]
@C    DepthBiases_id157 => ShadowMapReceiverBase.DepthBiases.directLightGroups[0]
@C    OffsetScales_id158 => ShadowMapReceiverBase.OffsetScales.directLightGroups[0]
@C    CascadeDepthSplits_id165 => ShadowMapReceiverDirectional.CascadeDepthSplits.directLightGroups[0]
@C    ClusterDepthScale_id177 => LightClustered.ClusterDepthScale
@C    ClusterDepthBias_id178 => LightClustered.ClusterDepthBias
@C    ClusterStride_id179 => LightClustered.ClusterStride
@C    AmbientLight_id182 => LightSimpleAmbient.AmbientLight.environmentLights[0]
@C    _padding_PerView_Lighting => _padding_PerView_Lighting
***************************
******  Resources    ******
***************************
@R    PerMaterial => PerMaterial [Stage: None, Slot: (-1--1)]
@R    EnvironmentLightingDFG_LUT_id213 => MaterialSpecularMicrofacetEnvironmentGGXLUT.EnvironmentLightingDFG_LUT [Stage: None, Slot: (-1--1)]
@R    EnvironmentLightingDFG_LUT_id213 => MaterialSpecularMicrofacetEnvironmentGGXLUT.EnvironmentLightingDFG_LUT [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: None, Slot: (-1--1)]
@R    LightClusters_id175 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightClusters_id175 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightIndices_id176 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    LightIndices_id176 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    PointLights_id180 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    PointLights_id180 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id181 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id181 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    PerDraw => PerDraw [Stage: Vertex, Slot: (0-0)]
@R    PerView => PerView [Stage: Vertex, Slot: (1-1)]
@R    LinearSampler_id122 => Texturing.LinearSampler [Stage: Pixel, Slot: (0-0)]
@R    LinearClampCompareLessEqualSampler_id124 => Texturing.LinearClampCompareLessEqualSampler [Stage: Pixel, Slot: (1-1)]
@R    EnvironmentLightingDFG_LUT_id213 => MaterialSpecularMicrofacetEnvironmentGGXLUT.EnvironmentLightingDFG_LUT [Stage: Pixel, Slot: (0-0)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: Pixel, Slot: (1-1)]
@R    LightClusters_id175 => LightClustered.LightClusters [Stage: Pixel, Slot: (2-2)]
@R    LightIndices_id176 => LightClustered.LightIndices [Stage: Pixel, Slot: (3-3)]
@R    PointLights_id180 => LightClusteredPointGroup.PointLights [Stage: Pixel, Slot: (4-4)]
@R    SpotLights_id181 => LightClusteredSpotGroup.SpotLights [Stage: Pixel, Slot: (5-5)]
@R    PerDraw => PerDraw [Stage: Pixel, Slot: (0-0)]
@R    PerMaterial => PerMaterial [Stage: Pixel, Slot: (1-1)]
@R    PerView => PerView [Stage: Pixel, Slot: (2-2)]
***************************
*****     Sources     *****
***************************
@S    ShaderBase => 01e372056ff6c06edab8e988414a8f75
@S    ShaderBaseStream => 91c0ea8aae0a45ca00578a4084fa3607
@S    ShadingBase => ffb632df632721ce2c25f1b6f505fc1e
@S    ComputeColor => 4f34177c1ace328c0f5ae9b3e880dac2
@S    TransformationBase => 8b17025a11a061cbf806a590fecff713
@S    NormalStream => 901c352015317e9dff7f9aef777dc0c7
@S    TransformationWAndVP => 4852381ef91335cbf665eca43a0eb5ee
@S    PositionStream4 => 978c413387a2cb385e61d6d096be6d21
@S    PositionHStream4 => 6a2c2e4bcfc42de2c49c69f480ead970
@S    Transformation => 6c40fce14b58a620257103f7d0f4c093
@S    NormalFromMesh => d6eccd1ce6aae826e4049d4e94b581a4
@S    NormalBase => 3e598ef48925debde0053f3469205f5f
@S    NormalUpdate => a1cefe3f75303b1c5857928c714e12bf
@S    MaterialSurfacePixelStageCompositor => 69d0c95661b93268f264d740adf7b8f4
@S    PositionStream => f29f571241be3db9dd2ec9688eb1db49
@S    MaterialPixelShadingStream => 9d583be145776e49c5a8377a978b0658
@S    MaterialPixelStream => ba54d20041c3b54e07f20babb85f60bb
@S    MaterialStream => 5add3babbb46e617235ca05953485ed8
@S    IStreamInitializer => 092b60c9fe32ce985421fcfe20a11072
@S    LightStream => 56c38b50a16fcb778c6eb6de86c307b5
@S    DirectLightGroupArray => eb6e08e566ca745bb06964c172175969
@S    DirectLightGroup => f340deae83183fca86789915a8f743c4
@S    ShadowGroup => 05578eeca4469db17e4a68e127e25a9f
@S    ShadowStream => 1adfec0b15bc9bf4d56e6be9b378a587
@S    TextureProjectionGroup => 48db91a31cbf2a9150d13547051adb85
@S    EnvironmentLightArray => 02bffee7c5265d75553f30029f1fbf48
@S    EnvironmentLight => aec79836f4a6429ad55d8efc9971a8d7
@S    IMaterialSurface => 993d0e1a3a0209ce4df727250c905ab8
@S    LightDirectionalGroup => ac53667662784343d421b00fac059f9a
@S    DirectLightGroupPerView => 8e17a5b08d2245289bb7a2dfb37a8dd8
@S    LightDirectional => a342c290a036eb9fbb9d93bdd7fa32de
@S    ShadowMapReceiverDirectional => 0bf9ec91d0d63d48d1ba26668b1f66ec
@S    ShadowMapReceiverBase => 378009624fef0fa663eadb2f18a1e67c
@S    ShadowMapGroup => 7cc147d3462fc743e45887d78f3ee6c4
@S    ShadowMapCommon => a636008e844a6b4cc640e0310830794e
@S    ShadowMapFilterBase => 92c4ea2f9b3a7a114f7d9d7556b97ea5
@S    Texturing => 6605f68230266eff2bc8b4e8102ede6b
@S    Math => 395aa210901b9e0783594d1b4fb0a441
@S    ShadowMapFilterPcf => 101a5eea4b5aec04d9bbfd95eee01fbc
@S    LightClusteredPointGroup => daa4f884feed02bad152ef53f5820771
@S    LightClustered => f939f2ab47789c1fd022283bcadfa42e
@S    ScreenPositionBase => 447b80ee2709564be56e617346288f78
@S    Camera => 68de88612bfb3b0a92e9082b82b993a9
@S    LightPoint => ffca22202bf34deee191bc36e95d9ccf
@S    LightUtil => 21256a4364432cc656447ee541333792
@S    LightClusteredSpotGroup => ae51eef97b7a5ad4cf63e15461308bdd
@S    LightSpot => ffc8735093683cafbdbc1f59643b9b8f
@S    SpotLightDataInternalShader => 5f0bd728a1c56b1def3b26d3859f6876
@S    LightSpotAttenuationDefault => 3764b4b242d09ba41b1a9cd5678ddf55
@S    LightSimpleAmbient => 6b7c24748a4d72e5eb22ae12802d3b2d
@S    MaterialSurfaceArray => 6c056e27887290fe2f9862991714228f
@S    MaterialSurfaceDiffuse => 4130aff8a17174b1b1457299185be45e
@S    IMaterialSurfacePixel => efa5da7adb861031599778e9829daca8
@S    Float4ToColor => 090c0c91c91b9d0b479ea3e773355055
@S    ComputeFloat4 => 6aeb31691af393d622350bb42f15ad31
@S    DoFloat4 => 39d0035e8f78b3fb7449b690dd1fcc91
@S    ComputeVoid => de97af339f497c4b8917a076af92194b
@S    ComputeOrder => 50906fabe772669b3f8af01fdd9c505d
@S    AssignVarFloat4 => e54e0b8e92e739bce2ac0f556badd874
@S    StreamVariableFloat4 => c2e6e06503f828c3a049b22513676b9e
@S    InputFloat4 => dde84bd708e467fe677dfda4ce575339
@S    DeclFloat4 => b2a3d29ab3b24927c9d8403a0245327b
@S    GetVarFloat4 => 9a12d35140d41c5c9743d8babe2b56e2
@S    MaterialSurfaceGlossinessMap => ec8934feb70f88c3bd9058130e6b7832
@S    FloatToScalar => 190ca2ba985be574ef882e8bdb8b38a2
@S    ComputeFloat => 2744918ba519afc956e367cbd1cb1fc4
@S    DoFloat => d050e0ec3f8e208b719183949cc88f11
@S    AssignVarFloat => a27c6bbf503fcc9e236bc94dd1c261bf
@S    StreamVariableFloat => 20a0c0292833cf8f573b776f121529c5
@S    InputFloat => edce7cfb3e88687e30d0d7dadcb5a90d
@S    DeclFloat => f4460ed7a64afae8a4c604a1f0434666
@S    GetVarFloat => 15ef45218ac83c53348d7e12dab45514
@S    MaterialSurfaceMetalness => 53f38107e2a3f588a066e5056cfbe194
@S    MaterialSurfaceLightingAndShading => 56a8877cd2af395727b11f69c761ad41
@S    IMaterialSurfaceShading => 86261e2a0ca0229f0d6ddf87490e5967
@S    MaterialSurfaceShadingDiffuseLambert => 9adb7783d6ea173f9f8ffdfa5c141256
@S    MaterialSurfaceShadingSpecularMicrofacet => 74a9cdfd18445f03ce98df19b4e5e5f0
@S    BRDFMicrofacet => 634bc8cd641b44251287c32dc4bb310b
@S    IMaterialSpecularMicrofacetFresnelFunction => 12e80a2bc796cfc576987299453cb890
@S    IMaterialSpecularMicrofacetVisibilityFunction => a8f975c174875f719493984daf60fab9
@S    IMaterialSpecularMicrofacetNormalDistributionFunction => fc5b438d6e5ae420d08b84f94299b658
@S    IMaterialSpecularMicrofacetEnvironmentFunction => 2faf111195f4b7802bc5194f4a9a62ee
@S    MaterialSpecularMicrofacetEnvironmentGGXLUT => 6f3fa570d4541f87cd04693e894e1856
@S    MaterialSpecularMicrofacetFresnelSchlick => 04e1a6d84795686816d85b78b9155ad8
@S    MaterialSpecularMicrofacetVisibilitySmithSchlickGGX => 45e27c12fa6ed8195f675a525b5df801
@S    MaterialSpecularMicrofacetNormalDistributionGGX => a9f1af90f24c65d1656e0b155aabc565
@S    GBufferOutputSubsurfaceScatteringMaterialIndex => 5df9471bf02401dc5db0de4bbd3d8abb
***************************
*****     Stages      *****
***************************
@G    Vertex => 22731900f4ca88603809638a49572b4d
//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer PerDraw
// {
//
//   float4x4 World_id32;               // Offset:    0 Size:    64
//   float4x4 WorldInverse_id33;        // Offset:   64 Size:    64 [unused]
//   float4x4 WorldInverseTranspose_id34;// Offset:  128 Size:    64
//   float4x4 WorldView_id35;           // Offset:  192 Size:    64 [unused]
//   float4x4 WorldViewInverse_id36;    // Offset:  256 Size:    64 [unused]
//   float4x4 WorldViewProjection_id37; // Offset:  320 Size:    64 [unused]
//   float3 WorldScale_id38;            // Offset:  384 Size:    12 [unused]
//   float4 EyeMS_id39;                 // Offset:  400 Size:    16 [unused]
//   uint MaterialIndex_id83;           // Offset:  416 Size:     4 [unused]
//
// }
//
// cbuffer PerView
// {
//
//   float4x4 View_id25;                // Offset:    0 Size:    64 [unused]
//   float4x4 ViewInverse_id26;         // Offset:   64 Size:    64 [unused]
//   float4x4 Projection_id27;          // Offset:  128 Size:    64 [unused]
//   float4x4 ProjectionInverse_id28;   // Offset:  192 Size:    64 [unused]
//   float4x4 ViewProjection_id29;      // Offset:  256 Size:    64
//   float2 ProjScreenRay_id30;         // Offset:  320 Size:     8 [unused]
//   float4 Eye_id31;                   // Offset:  336 Size:    16 [unused]
//   float NearClipPlane_id168;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id169;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id170;          // Offset:  360 Size:     8 [unused]
//   float2 ViewSize_id171;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id172;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[2];                  // Offset:  416 Size:    60 [unused]
//   float2 ShadowMapTextureSize_id90;  // Offset:  480 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id91;// Offset:  488 Size:     8 [unused]
//   float4x4 WorldToShadowCascadeUV_id153[8];// Offset:  496 Size:   512 [unused]
//   float4x4 InverseWorldToShadowCascadeUV_id154[8];// Offset: 1008 Size:   512 [unused]
//   float4x4 ViewMatrices_id155[8];    // Offset: 1520 Size:   512 [unused]
//   float2 DepthRanges_id156[8];       // Offset: 2032 Size:   120 [unused]
//   float DepthBiases_id157[2];        // Offset: 2160 Size:    20 [unused]
//   float OffsetScales_id158[2];       // Offset: 2192 Size:    20 [unused]
//   float CascadeDepthSplits_id165[8]; // Offset: 2224 Size:   116 [unused]
//   float ClusterDepthScale_id177;     // Offset: 2340 Size:     4 [unused]
//   float ClusterDepthBias_id178;      // Offset: 2344 Size:     4 [unused]
//   float2 ClusterStride_id179;        // Offset: 2352 Size:     8 [unused]
//   float3 AmbientLight_id182;         // Offset: 2368 Size:    12 [unused]
//   float4 _padding_PerView_Lighting;  // Offset: 2384 Size:    16 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// PerDraw                           cbuffer      NA          NA            cb0      1 
// PerView                           cbuffer      NA          NA            cb1      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION                 0   xyzw        0     NONE   float   xyzw
// NORMAL                   0   xyz         1     NONE   float   xyz 
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION_WS              0   xyzw        0     NONE   float   xyzw
// SV_Position              0   xyzw        1      POS   float   xyzw
// DEPTH_VS                 0   x           2     NONE   float   x   
// NORMALWS                 0    yzw        2     NONE   float    yzw
// SCREENPOSITION_ID167_SEM     0   xyzw        3     NONE   float   xyzw
//
vs_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[11], immediateIndexed
dcl_constantbuffer CB1[20], immediateIndexed
dcl_input v0.xyzw
dcl_input v1.xyz
dcl_output o0.xyzw
dcl_output_siv o1.xyzw, position
dcl_output o2.x
dcl_output o2.yzw
dcl_output o3.xyzw
dcl_temps 2
//
// Initial variable locations:
//   v0.x <- __input__.Position_id21.x; v0.y <- __input__.Position_id21.y; v0.z <- __input__.Position_id21.z; v0.w <- __input__.Position_id21.w; 
//   v1.x <- __input__.meshNormal_id16.x; v1.y <- __input__.meshNormal_id16.y; v1.z <- __input__.meshNormal_id16.z; 
//   o3.x <- <VSMain return value>.ScreenPosition_id167.x; o3.y <- <VSMain return value>.ScreenPosition_id167.y; o3.z <- <VSMain return value>.ScreenPosition_id167.z; o3.w <- <VSMain return value>.ScreenPosition_id167.w; 
//   o2.x <- <VSMain return value>.DepthVS_id23; o2.y <- <VSMain return value>.normalWS_id19.x; o2.z <- <VSMain return value>.normalWS_id19.y; o2.w <- <VSMain return value>.normalWS_id19.z; 
//   o1.x <- <VSMain return value>.ShadingPosition_id0.x; o1.y <- <VSMain return value>.ShadingPosition_id0.y; o1.z <- <VSMain return value>.ShadingPosition_id0.z; o1.w <- <VSMain return value>.ShadingPosition_id0.w; 
//   o0.x <- <VSMain return value>.PositionWS_id22.x; o0.y <- <VSMain return value>.PositionWS_id22.y; o0.z <- <VSMain return value>.PositionWS_id22.z; o0.w <- <VSMain return value>.PositionWS_id22.w
//
#line 1173 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_2a925d3b99db4efd4d433506591e141b.hlsl"
dp4 r0.x, v0.xyzw, cb0[0].xyzw  // r0.x <- streams.PositionWS_id22.x
dp4 r0.y, v0.xyzw, cb0[1].xyzw  // r0.y <- streams.PositionWS_id22.y
dp4 r0.z, v0.xyzw, cb0[2].xyzw  // r0.z <- streams.PositionWS_id22.z
dp4 r0.w, v0.xyzw, cb0[3].xyzw  // r0.w <- streams.PositionWS_id22.w

#line 1260
mov o0.xyzw, r0.xyzw

#line 1128
dp4 r1.x, r0.xyzw, cb1[16].xyzw  // r1.x <- <ComputeShadingPosition_id11 return value>.x
dp4 r1.y, r0.xyzw, cb1[17].xyzw  // r1.y <- <ComputeShadingPosition_id11 return value>.y
dp4 r1.z, r0.xyzw, cb1[18].xyzw  // r1.z <- <ComputeShadingPosition_id11 return value>.z
dp4 r1.w, r0.xyzw, cb1[19].xyzw  // r1.w <- <ComputeShadingPosition_id11 return value>.w

#line 1260
mov o1.xyzw, r1.xyzw
mov o3.xyzw, r1.xyzw
mov o2.x, r1.w

#line 1213
dp3 o2.y, v1.xyzx, cb0[8].xyzx
dp3 o2.z, v1.xyzx, cb0[9].xyzx
dp3 o2.w, v1.xyzx, cb0[10].xyzx

#line 1260
ret 
// Approximately 16 instruction slots used
@G    Pixel => 0ff65a3284b0403c88852f25262108a8
//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer PerDraw
// {
//
//   float4x4 World_id32;               // Offset:    0 Size:    64 [unused]
//   float4x4 WorldInverse_id33;        // Offset:   64 Size:    64 [unused]
//   float4x4 WorldInverseTranspose_id34;// Offset:  128 Size:    64 [unused]
//   float4x4 WorldView_id35;           // Offset:  192 Size:    64 [unused]
//   float4x4 WorldViewInverse_id36;    // Offset:  256 Size:    64 [unused]
//   float4x4 WorldViewProjection_id37; // Offset:  320 Size:    64 [unused]
//   float3 WorldScale_id38;            // Offset:  384 Size:    12 [unused]
//   float4 EyeMS_id39;                 // Offset:  400 Size:    16 [unused]
//   uint MaterialIndex_id83;           // Offset:  416 Size:     4
//
// }
//
// cbuffer PerMaterial
// {
//
//   float4 InputValue_id184;           // Offset:    0 Size:    16
//   float InputValue_id192;            // Offset:   16 Size:     4
//   float InputValue_id201;            // Offset:   20 Size:     4
//
// }
//
// cbuffer PerView
// {
//
//   float4x4 View_id25;                // Offset:    0 Size:    64 [unused]
//   float4x4 ViewInverse_id26;         // Offset:   64 Size:    64 [unused]
//   float4x4 Projection_id27;          // Offset:  128 Size:    64 [unused]
//   float4x4 ProjectionInverse_id28;   // Offset:  192 Size:    64 [unused]
//   float4x4 ViewProjection_id29;      // Offset:  256 Size:    64 [unused]
//   float2 ProjScreenRay_id30;         // Offset:  320 Size:     8 [unused]
//   float4 Eye_id31;                   // Offset:  336 Size:    16
//   float NearClipPlane_id168;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id169;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id170;          // Offset:  360 Size:     8
//   float2 ViewSize_id171;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id172;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[2];                  // Offset:  416 Size:    60
//   float2 ShadowMapTextureSize_id90;  // Offset:  480 Size:     8
//   float2 ShadowMapTextureTexelSize_id91;// Offset:  488 Size:     8
//   float4x4 WorldToShadowCascadeUV_id153[8];// Offset:  496 Size:   512
//   float4x4 InverseWorldToShadowCascadeUV_id154[8];// Offset: 1008 Size:   512 [unused]
//   float4x4 ViewMatrices_id155[8];    // Offset: 1520 Size:   512 [unused]
//   float2 DepthRanges_id156[8];       // Offset: 2032 Size:   120 [unused]
//   float DepthBiases_id157[2];        // Offset: 2160 Size:    20
//   float OffsetScales_id158[2];       // Offset: 2192 Size:    20
//   float CascadeDepthSplits_id165[8]; // Offset: 2224 Size:   116
//   float ClusterDepthScale_id177;     // Offset: 2340 Size:     4
//   float ClusterDepthBias_id178;      // Offset: 2344 Size:     4
//   float2 ClusterStride_id179;        // Offset: 2352 Size:     8
//   float3 AmbientLight_id182;         // Offset: 2368 Size:    12
//   float4 _padding_PerView_Lighting;  // Offset: 2384 Size:    16 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// LinearSampler_id122               sampler      NA          NA             s0      1 
// LinearClampCompareLessEqualSampler_id124  sampler_c      NA          NA             s1      1 
// EnvironmentLightingDFG_LUT_id213    texture  float4          2d             t0      1 
// ShadowMapTexture_id89             texture  float4          2d             t1      1 
// LightClusters_id175               texture   uint2          3d             t2      1 
// LightIndices_id176                texture    uint         buf             t3      1 
// PointLights_id180                 texture  float4         buf             t4      1 
// SpotLights_id181                  texture  float4         buf             t5      1 
// PerDraw                           cbuffer      NA          NA            cb0      1 
// PerMaterial                       cbuffer      NA          NA            cb1      1 
// PerView                           cbuffer      NA          NA            cb2      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION_WS              0   xyzw        0     NONE   float   xyz 
// SV_Position              0   xyzw        1      POS   float     z 
// DEPTH_VS                 0   x           2     NONE   float   x   
// NORMALWS                 0    yzw        2     NONE   float    yzw
// SCREENPOSITION_ID167_SEM     0   xyzw        3     NONE   float   xy w
// SV_IsFrontFace           0   x           4    FFACE    uint   x   
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_Target                0   xyzw        0   TARGET   float   xyzw
// SV_Target                1   xyzw        1   TARGET   float   xyzw
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[27], immediateIndexed
dcl_constantbuffer CB1[2], immediateIndexed
dcl_constantbuffer CB2[149], dynamicIndexed
dcl_sampler s0, mode_default
dcl_sampler s1, mode_comparison
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t1
dcl_resource_texture3d (uint,uint,uint,uint) t2
dcl_resource_buffer (uint,uint,uint,uint) t3
dcl_resource_buffer (float,float,float,float) t4
dcl_resource_buffer (float,float,float,float) t5
dcl_input_ps linear v0.xyz
dcl_input_ps_siv linear noperspective v1.z, position
dcl_input_ps linear v2.x
dcl_input_ps linear v2.yzw
dcl_input_ps linear v3.xyw
dcl_input_ps_sgv constant v4.x, is_front_face
dcl_output o0.xyzw
dcl_output o1.xyzw
dcl_temps 21
//
// Initial variable locations:
//   v0.x <- __input__.PositionWS_id22.x; v0.y <- __input__.PositionWS_id22.y; v0.z <- __input__.PositionWS_id22.z; v0.w <- __input__.PositionWS_id22.w; 
//   v1.x <- __input__.ShadingPosition_id0.x; v1.y <- __input__.ShadingPosition_id0.y; v1.z <- __input__.ShadingPosition_id0.z; v1.w <- __input__.ShadingPosition_id0.w; 
//   v2.x <- __input__.DepthVS_id23; v2.y <- __input__.normalWS_id19.x; v2.z <- __input__.normalWS_id19.y; v2.w <- __input__.normalWS_id19.z; 
//   v3.x <- __input__.ScreenPosition_id167.x; v3.y <- __input__.ScreenPosition_id167.y; v3.z <- __input__.ScreenPosition_id167.z; v3.w <- __input__.ScreenPosition_id167.w; 
//   v4.x <- __input__.IsFrontFace_id1; 
//   o1.x <- <PSMain return value>.ColorTarget1_id3.x; o1.y <- <PSMain return value>.ColorTarget1_id3.y; o1.z <- <PSMain return value>.ColorTarget1_id3.z; o1.w <- <PSMain return value>.ColorTarget1_id3.w; 
//   o0.x <- <PSMain return value>.ColorTarget_id2.x; o0.y <- <PSMain return value>.ColorTarget_id2.y; o0.z <- <PSMain return value>.ColorTarget_id2.z; o0.w <- <PSMain return value>.ColorTarget_id2.w
//
#line 1240 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_2a925d3b99db4efd4d433506591e141b.hlsl"
div r0.xy, v3.xyxx, v3.wwww  // r0.x <- streams.ScreenPosition_id167.x; r0.y <- streams.ScreenPosition_id167.y

#line 1207
dp3 r0.z, v2.yzwy, v2.yzwy
lt r0.w, l(0.000000), r0.z

#line 1208
rsq r0.z, r0.z
mul r1.xyz, r0.zzzz, v2.yzwy  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z
movc r1.xyz, r0.wwww, r1.xyzx, v2.yzwy

#line 1181
add r2.xyz, -v0.xyzx, cb2[21].xyzx
dp3 r0.z, r2.xyzx, r2.xyzx
rsq r0.z, r0.z
mul r2.xyz, r0.zzzz, r2.xyzx  // r2.x <- streams.viewWS_id68.x; r2.y <- streams.viewWS_id68.y; r2.z <- streams.viewWS_id68.z

#line 1092
add r0.z, -cb1[1].x, l(1.000000)  // r0.z <- glossiness

#line 1084
add r3.xyz, cb1[0].xyzx, l(-0.020000, -0.020000, -0.020000, 0.000000)
mad r3.xyz, cb1[1].yyyy, r3.xyzx, l(0.020000, 0.020000, 0.020000, 0.000000)  // r3.x <- streams.matSpecular_id55.x; r3.y <- streams.matSpecular_id55.y; r3.z <- streams.matSpecular_id55.z

#line 1085
mad r4.xyz, cb1[1].yyyy, -cb1[0].xyzx, cb1[0].xyzx  // r4.x <- streams.matDiffuse_id53.x; r4.y <- streams.matDiffuse_id53.y; r4.z <- streams.matDiffuse_id53.z

#line 961
movc r1.xyz, v4.xxxx, r1.xyzx, -r1.xyzx  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z

#line 918
dp3 r0.w, r1.xyzx, r2.xyzx
max r5.y, r0.w, l(0.000100)  // r5.y <- streams.NdotV_id72

#line 919
add r0.z, -r0.z, l(1.000000)  // r0.z <- roughness

#line 920
mul r0.z, r0.z, r0.z
max r0.z, r0.z, l(0.001000)  // r0.z <- streams.alphaRoughness_id70

#line 596
add r0.w, cb2[30].z, cb2[30].z

#line 588
mov r6.w, l(1.000000)

#line 979
mov r1.w, r5.y  // r1.w <- streams.NdotV_id72
mov r7.xyz, r1.xyzx  // r7.x <- streams.normalWS_id19.x; r7.y <- streams.normalWS_id19.y; r7.z <- streams.normalWS_id19.z
mov r7.w, v0.x  // r7.w <- streams.PositionWS_id22.x
mov r8.xy, v0.yzyy  // r8.x <- streams.PositionWS_id22.y; r8.y <- streams.PositionWS_id22.z
mov r8.zw, r2.xxxy  // r8.z <- streams.viewWS_id68.x; r8.w <- streams.viewWS_id68.y
mov r9.z, r2.z  // r9.z <- streams.viewWS_id68.z
mov r10.xyz, r4.xyzx  // r10.x <- streams.matDiffuseVisible_id69.x; r10.y <- streams.matDiffuseVisible_id69.y; r10.z <- streams.matDiffuseVisible_id69.z
mov r11.xyz, r3.xyzx  // r11.x <- streams.matSpecularVisible_id71.x; r11.y <- streams.matSpecularVisible_id71.y; r11.z <- streams.matSpecularVisible_id71.z
mov r11.w, r0.z  // r11.w <- streams.alphaRoughness_id70
mov r12.xyz, l(0,0,0,0)  // r12.x <- directLightingContribution.x; r12.y <- directLightingContribution.y; r12.z <- directLightingContribution.z
mov r2.w, v2.x  // r2.w <- streams.DepthVS_id23
mov r3.w, l(0)  // r3.w <- i
loop 
  ige r4.w, r3.w, l(2)
  breakc_nz r4.w

#line 981
  ige r4.w, r3.w, cb2[25].x
  if_nz r4.w

#line 983
    break 

#line 984
  endif 

#line 726
  ishl r5.zw, r3.wwww, l(0, 0, 1, 2)  // r5.w <- cascadeIndexBase

#line 888
  dp3 r4.w, r7.xyzx, -cb2[r5.z + 26].xyzx
  max r4.w, r4.w, l(0.000100)  // r4.w <- streams.NdotL_id49

#line 733
  lt r9.w, cb2[r5.w + 139].x, r2.w

#line 736
  and r9.w, r9.w, l(1)  // r9.w <- cascadeIndex

#line 733
  bfi r13.xy, l(30, 30, 0, 0), l(2, 2, 0, 0), r3.wwww, l(1, 2, 0, 0)
  lt r10.w, cb2[r13.x + 139].x, r2.w

#line 736
  movc r9.w, r10.w, l(2), r9.w

#line 733
  lt r10.w, cb2[r13.y + 139].x, r2.w

#line 736
  movc r9.w, r10.w, l(3), r9.w

#line 595
  add r12.w, -r4.w, l(1.000000)
  max r12.w, r12.w, l(0.000000)  // r12.w <- normalOffsetScale

#line 596
  mul r13.x, r0.w, cb2[r3.w + 137].x
  mul r12.w, r12.w, r13.x

#line 741
  mov r13.x, r7.w
  mov r13.yz, r8.xxyx
  mad r6.xyz, r12.wwww, r7.xyzx, r13.xyzx  // r6.x <- shadowPosition.x; r6.y <- shadowPosition.y; r6.z <- shadowPosition.z

#line 588
  bfi r12.w, l(30), l(2), r3.w, r9.w
  ishl r13.x, r9.w, l(2)
  bfi r13.x, l(30), l(4), r3.w, r13.x
  dp4 r14.x, r6.xyzw, cb2[r13.x + 31].xyzw  // r14.x <- shadowPosition.x
  dp4 r14.y, r6.xyzw, cb2[r13.x + 32].xyzw  // r14.y <- shadowPosition.y
  dp4 r13.y, r6.xyzw, cb2[r13.x + 33].xyzw  // r13.y <- shadowPosition.z
  dp4 r13.x, r6.xyzw, cb2[r13.x + 34].xyzw  // r13.x <- shadowPosition.w

#line 589
  add r14.z, r13.y, -cb2[r3.w + 135].x  // r14.z <- shadowPosition.z

#line 590
  div r13.xyz, r14.xyzx, r13.xxxx  // r13.x <- shadowPosition.x; r13.y <- shadowPosition.y; r13.z <- shadowPosition.z

#line 457
  mad r13.xy, r13.xyxx, cb2[30].xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  round_ni r14.xy, r13.xyxx  // r14.x <- base_uv.x; r14.y <- base_uv.y

#line 458
  add r13.xy, r13.xyxx, -r14.xyxx  // r13.x <- st.x; r13.y <- st.y

#line 459
  add r14.xy, r14.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)

#line 460
  mul r14.xy, r14.xyxx, cb2[30].zwzz

#line 321
  mad r14.zw, -r13.yyyx, l(0.000000, 0.000000, 3.000000, 3.000000), l(0.000000, 0.000000, 4.000000, 4.000000)  // r14.z <- uvW0.y; r14.w <- uvW0.x

#line 323
  mad r15.xy, r13.xyxx, l(3.000000, 3.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)  // r15.x <- uvW2.x; r15.y <- uvW2.y

#line 324
  mad r15.zw, -r13.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
  div r15.zw, r15.zzzw, r14.wwwz
  add r16.xw, r15.zzzw, l(-2.000000, 0.000000, 0.000000, -2.000000)  // r16.x <- uv0.x; r16.w <- uv0.y

#line 325
  add r15.zw, r13.xxxy, l(0.000000, 0.000000, 3.000000, 3.000000)
  mul r16.yz, r15.wwzw, l(0.000000, 0.142857, 0.142857, 0.000000)  // r16.y <- uv1.y; r16.z <- uv1.x

#line 326
  div r13.xy, r13.xyxx, r15.xyxx
  add r17.xy, r13.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000)  // r17.x <- uv2.x; r17.y <- uv2.y

#line 327
  mul r13.x, r14.z, r14.w

#line 328
  mad r18.xyzw, r16.xwzw, cb2[30].zwzw, r14.xyxy

#line 332
  mov r17.zw, r16.wwwy

#line 330
  mul r13.yw, r14.zzzw, l(0.000000, 7.000000, 0.000000, 7.000000)

#line 331
  mad r19.xyzw, r16.xyzy, cb2[30].zwzw, r14.xyxy

#line 332
  mad r20.xyzw, r17.xzxw, cb2[30].zwzw, r14.xyxy

#line 333
  mov r16.y, r17.y
  mul r14.zw, r14.zzzw, r15.xxxy

#line 334
  mad r16.xyzw, r16.xyzy, cb2[30].zwzw, r14.xyxy
  mul r15.zw, r15.xxxy, l(0.000000, 0.000000, 7.000000, 7.000000)

#line 335
  mad r14.xy, r17.xyxx, cb2[30].zwzz, r14.xyxx
  mul r15.x, r15.y, r15.x

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r15.y, r18.xyxx, t1.xxxx, s1, r13.z  // r15.y <- <SampleTextureAndCompare_id65 return value>
  sample_c_lz_indexable(texture2d)(float,float,float,float) r17.x, r18.zwzz, t1.xxxx, s1, r13.z  // r17.x <- <SampleTextureAndCompare_id65 return value>

#line 532
  mul r13.y, r13.y, r17.x
  mad r13.x, r13.x, r15.y, r13.y  // r13.x <- shadow

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r13.y, r20.xyxx, t1.xxxx, s1, r13.z  // r13.y <- <SampleTextureAndCompare_id65 return value>

#line 532
  mad r13.x, r14.z, r13.y, r13.x

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r13.y, r19.xyxx, t1.xxxx, s1, r13.z

#line 532
  mad r13.x, r13.w, r13.y, r13.x

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r13.y, r19.zwzz, t1.xxxx, s1, r13.z

#line 532
  mad r13.x, r13.y, l(49.000000), r13.x

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r13.y, r20.zwzz, t1.xxxx, s1, r13.z

#line 532
  mad r13.x, r15.z, r13.y, r13.x

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r13.y, r16.xyxx, t1.xxxx, s1, r13.z

#line 532
  mad r13.x, r14.w, r13.y, r13.x

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r13.y, r16.zwzz, t1.xxxx, s1, r13.z

#line 532
  mad r13.x, r15.w, r13.y, r13.x

#line 452
  sample_c_lz_indexable(texture2d)(float,float,float,float) r13.y, r14.xyxx, t1.xxxx, s1, r13.z

#line 532
  mad r13.x, r15.x, r13.y, r13.x

#line 534
  mul r13.yzw, r13.xxxx, l(0.000000, 0.006944, 0.006944, 0.006944)  // r13.w <- shadow

#line 747
  ilt r14.x, l(0), r9.w
  if_nz r14.x

#line 749
    iadd r14.x, r12.w, l(-1)
    add r14.x, -cb2[r14.x + 139].x, cb2[r12.w + 139].x  // r14.x <- splitSize

#line 750
  else 
    mov r14.x, cb2[r12.w + 139].x  // r14.x <- splitSize
  endif 

#line 751
  add r12.w, -r2.w, cb2[r12.w + 139].x
  div r12.w, r12.w, r14.x  // r12.w <- splitDist

#line 752
  lt r14.x, r12.w, l(0.200000)
  if_nz r14.x

#line 755
    if_nz r10.w

#line 757
      mov r13.yzw, r13.wwww  // r13.y <- shadow.x; r13.z <- shadow.y; r13.w <- shadow.z
    else 

#line 754
      mul_sat r10.w, r12.w, l(5.000000)
      mad r12.w, r10.w, l(-2.000000), l(3.000000)
      mul r10.w, r10.w, r10.w
      mul r10.w, r10.w, r12.w  // r10.w <- lerpAmt

#line 588
      ishl r5.w, r5.w, l(2)
      imad r5.w, r9.w, l(4), r5.w
      iadd r5.w, r5.w, l(4)
      dp4 r14.x, r6.xyzw, cb2[r5.w + 31].xyzw  // r14.x <- shadowPosition.x
      dp4 r14.y, r6.xyzw, cb2[r5.w + 32].xyzw  // r14.y <- shadowPosition.y
      dp4 r9.w, r6.xyzw, cb2[r5.w + 33].xyzw  // r9.w <- shadowPosition.z
      dp4 r5.w, r6.xyzw, cb2[r5.w + 34].xyzw  // r5.w <- shadowPosition.w

#line 589
      add r14.z, r9.w, -cb2[r3.w + 135].x  // r14.z <- shadowPosition.z

#line 590
      div r6.xyz, r14.xyzx, r5.wwww  // r6.x <- shadowPosition.x; r6.y <- shadowPosition.y; r6.z <- shadowPosition.z

#line 457
      mad r6.xy, r6.xyxx, cb2[30].xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
      round_ni r14.xy, r6.xyxx  // r14.x <- base_uv.x; r14.y <- base_uv.y

#line 458
      add r6.xy, r6.xyxx, -r14.xyxx  // r6.x <- st.x; r6.y <- st.y

#line 459
      add r14.xy, r14.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)

#line 460
      mul r14.xy, r14.xyxx, cb2[30].zwzz

#line 321
      mad r14.zw, -r6.yyyx, l(0.000000, 0.000000, 3.000000, 3.000000), l(0.000000, 0.000000, 4.000000, 4.000000)  // r14.z <- uvW0.y; r14.w <- uvW0.x

#line 323
      mad r15.xy, r6.xyxx, l(3.000000, 3.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)  // r15.x <- uvW2.x; r15.y <- uvW2.y

#line 324
      mad r15.zw, -r6.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
      div r15.zw, r15.zzzw, r14.wwwz
      add r16.xw, r15.zzzw, l(-2.000000, 0.000000, 0.000000, -2.000000)  // r16.x <- uv0.x; r16.w <- uv0.y

#line 325
      add r15.zw, r6.xxxy, l(0.000000, 0.000000, 3.000000, 3.000000)
      mul r16.yz, r15.wwzw, l(0.000000, 0.142857, 0.142857, 0.000000)  // r16.y <- uv1.y; r16.z <- uv1.x

#line 326
      div r6.xy, r6.xyxx, r15.xyxx
      add r17.xy, r6.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000)  // r17.x <- uv2.x; r17.y <- uv2.y

#line 327
      mul r5.w, r14.z, r14.w

#line 328
      mad r18.xyzw, r16.xwzw, cb2[30].zwzw, r14.xyxy

#line 332
      mov r17.zw, r16.wwwy

#line 330
      mul r6.xy, r14.zwzz, l(7.000000, 7.000000, 0.000000, 0.000000)

#line 331
      mad r19.xyzw, r16.xyzy, cb2[30].zwzw, r14.xyxy

#line 332
      mad r20.xyzw, r17.xzxw, cb2[30].zwzw, r14.xyxy

#line 333
      mov r16.y, r17.y
      mul r14.zw, r14.zzzw, r15.xxxy

#line 334
      mad r16.xyzw, r16.xyzy, cb2[30].zwzw, r14.xyxy
      mul r15.zw, r15.xxxy, l(0.000000, 0.000000, 7.000000, 7.000000)

#line 335
      mad r14.xy, r17.xyxx, cb2[30].zwzz, r14.xyxx
      mul r9.w, r15.y, r15.x

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r12.w, r18.xyxx, t1.xxxx, s1, r6.z  // r12.w <- <SampleTextureAndCompare_id65 return value>
      sample_c_lz_indexable(texture2d)(float,float,float,float) r15.x, r18.zwzz, t1.xxxx, s1, r6.z  // r15.x <- <SampleTextureAndCompare_id65 return value>

#line 532
      mul r6.x, r6.x, r15.x
      mad r5.w, r5.w, r12.w, r6.x  // r5.w <- shadow

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r20.xyxx, t1.xxxx, s1, r6.z  // r6.x <- <SampleTextureAndCompare_id65 return value>

#line 532
      mad r5.w, r14.z, r6.x, r5.w

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r19.xyxx, t1.xxxx, s1, r6.z

#line 532
      mad r5.w, r6.y, r6.x, r5.w

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r19.zwzz, t1.xxxx, s1, r6.z

#line 532
      mad r5.w, r6.x, l(49.000000), r5.w

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r20.zwzz, t1.xxxx, s1, r6.z

#line 532
      mad r5.w, r15.z, r6.x, r5.w

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r16.xyxx, t1.xxxx, s1, r6.z

#line 532
      mad r5.w, r14.w, r6.x, r5.w

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r16.zwzz, t1.xxxx, s1, r6.z

#line 532
      mad r5.w, r15.w, r6.x, r5.w

#line 452
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r14.xyxx, t1.xxxx, s1, r6.z

#line 532
      mad r5.w, r9.w, r6.x, r5.w

#line 534
      mul r5.w, r5.w, l(0.006944)

#line 761
      mad r6.x, r13.x, l(0.006944), -r5.w
      mad r13.yzw, r10.wwww, r6.xxxx, r5.wwww  // r13.y <- shadow.x; r13.z <- shadow.y; r13.w <- shadow.z

#line 762
    endif 

#line 763
  endif 

#line 890
  mul r6.xyz, r13.yzwy, cb2[r5.z + 27].xyzx
  mul r6.xyz, r4.wwww, r6.xyzx  // r6.x <- streams.lightColorNdotL_id44.x; r6.y <- streams.lightColorNdotL_id44.y; r6.z <- streams.lightColorNdotL_id44.z

#line 880
  mov r9.xy, r8.zwzz
  add r9.xyw, r9.xyxz, -cb2[r5.z + 26].xyxz
  dp3 r5.w, r9.xywx, r9.xywx
  rsq r5.w, r5.w
  mul r9.xyw, r5.wwww, r9.xyxw  // r9.x <- streams.H_id75.x; r9.y <- streams.H_id75.y; r9.w <- streams.H_id75.z

#line 881
  dp3_sat r5.w, r7.xyzx, r9.xywx  // r5.w <- streams.NdotH_id76

#line 882
  dp3_sat r5.z, -cb2[r5.z + 26].xyzx, r9.xywx  // r5.z <- streams.LdotH_id77

#line 876
  mul r9.xyw, r6.xyxz, r10.xyxz

#line 989
  mad r9.xyw, r9.xyxw, l(0.318310, 0.318310, 0.000000, 0.318310), r12.xyxz  // r9.x <- directLightingContribution.x; r9.y <- directLightingContribution.y; r9.w <- directLightingContribution.z

#line 502
  add r13.xyz, -r11.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r5.z, -r5.z, l(1.000000)
  mul r10.w, r5.z, r5.z
  mul r10.w, r10.w, r10.w
  mul r5.z, r5.z, r10.w
  mad r13.xyz, r13.xyzx, r5.zzzz, r11.xyzx  // r13.x <- <FresnelSchlick_id140 return value>.x; r13.y <- <FresnelSchlick_id140 return value>.y; r13.z <- <FresnelSchlick_id140 return value>.z

#line 497
  mul r5.z, r11.w, l(0.500000)  // r5.z <- k

#line 498
  mad r10.w, -r11.w, l(0.500000), l(1.000000)
  mad r12.w, r4.w, r10.w, r5.z
  div r12.w, r4.w, r12.w  // r12.w <- <VisibilityhSchlickGGX_id156 return value>
  mad r5.z, r1.w, r10.w, r5.z
  div r5.z, r1.w, r5.z  // r5.z <- <VisibilityhSchlickGGX_id156 return value>

#line 575
  mul r5.z, r5.z, r12.w
  mul r4.w, r1.w, r4.w
  div r4.w, r5.z, r4.w  // r4.w <- <VisibilitySmithSchlickGGX_id158 return value>

#line 569
  mul r5.z, r11.w, r11.w  // r5.z <- alphaR2

#line 570
  mul r5.w, r5.w, r5.w
  mad r10.w, r11.w, r11.w, l(-1.000000)
  mad r5.w, r5.w, r10.w, l(1.000000)
  max r5.w, r5.w, l(0.000100)  // r5.w <- d

#line 571
  mul r5.w, r5.w, r5.w
  mul r5.w, r5.w, l(3.141593)
  div r5.z, r5.z, r5.w  // r5.z <- <NormalDistributionGGX_id170 return value>

#line 870
  mul r13.xyz, r4.wwww, r13.xyzx
  mul r13.xyz, r5.zzzz, r13.xyzx
  mul r6.xyz, r6.xyzx, r13.xyzx

#line 993
  mad r12.xyz, r6.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r9.xywx  // r12.x <- directLightingContribution.x; r12.y <- directLightingContribution.y; r12.z <- directLightingContribution.z

#line 979
  iadd r3.w, r3.w, l(1)

#line 995
endloop 

#line 698
add r0.w, v1.z, -cb2[22].z
div r0.w, cb2[22].w, r0.w  // r0.w <- depth

#line 699
mad r0.xy, r0.xyxx, l(1.000000, -1.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
mul r0.xy, r0.xyxx, cb2[147].xyxx

#line 700
mad r0.w, r0.w, cb2[146].y, cb2[146].z
log r0.w, r0.w
max r0.w, r0.w, l(0.000000)

#line 701
mul r0.xy, r0.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)

#line 700
ftoi r6.xyz, r0.xywx  // r6.z <- slice

#line 701
mov r6.w, l(0)
ld_indexable(texture3d)(uint,uint,uint,uint) r0.xy, r6.xyzw, t2.xyzw  // r0.x <- streams.lightData_id173.x; r0.y <- streams.lightData_id173.y

#line 858
and r0.w, r0.y, l(0x0000ffff)  // r0.w <- <GetMaxLightCount_id211 return value>

#line 1003
mov r6.xyz, r1.xyzx  // r6.x <- streams.normalWS_id19.x; r6.y <- streams.normalWS_id19.y; r6.z <- streams.normalWS_id19.z
mov r6.w, v0.x  // r6.w <- streams.PositionWS_id22.x
mov r7.xy, v0.yzyy  // r7.x <- streams.PositionWS_id22.y; r7.y <- streams.PositionWS_id22.z
mov r7.zw, r2.xxxy  // r7.z <- streams.viewWS_id68.x; r7.w <- streams.viewWS_id68.y
mov r8.z, r2.z  // r8.z <- streams.viewWS_id68.z
mov r9.xyz, r4.xyzx  // r9.x <- streams.matDiffuseVisible_id69.x; r9.y <- streams.matDiffuseVisible_id69.y; r9.z <- streams.matDiffuseVisible_id69.z
mov r10.xyz, r3.xyzx  // r10.x <- streams.matSpecularVisible_id71.x; r10.y <- streams.matSpecularVisible_id71.y; r10.z <- streams.matSpecularVisible_id71.z
mov r10.w, r0.z  // r10.w <- streams.alphaRoughness_id70
mov r5.w, r5.y  // r5.w <- streams.NdotV_id72
mov r5.z, r0.x  // r5.z <- streams.lightIndex_id174
mov r11.xyz, r12.xyzx  // r11.x <- directLightingContribution.x; r11.y <- directLightingContribution.y; r11.z <- directLightingContribution.z
mov r1.w, l(0)  // r1.w <- i
loop 
  ige r2.w, r1.w, r0.w
  breakc_nz r2.w

#line 1005
  if_nz r2.w

#line 1007
    break 

#line 1008
  endif 

#line 685
  ld_indexable(buffer)(uint,uint,uint,uint) r2.w, r5.zzzz, t3.yzwx  // r2.w <- realLightIndex

#line 686
  iadd r5.z, r5.z, l(1)  // r5.z <- streams.lightIndex_id174

#line 688
  ishl r3.w, r2.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r13.xyzw, r3.wwww, t4.xyzw  // r13.x <- pointLight1.x; r13.y <- pointLight1.y; r13.z <- pointLight1.z; r13.w <- pointLight1.w

#line 689
  bfi r2.w, l(31), l(1), r2.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r14.xyz, r2.wwww, t4.xyzw  // r14.x <- pointLight2.x; r14.y <- pointLight2.y; r14.z <- pointLight2.z

#line 489
  mov r15.x, r6.w
  mov r15.yz, r7.xxyx
  add r13.xyz, r13.xyzx, -r15.xyzx  // r13.x <- lightVector.x; r13.y <- lightVector.y; r13.z <- lightVector.z

#line 490
  dp3 r2.w, r13.xyzx, r13.xyzx
  sqrt r3.w, r2.w  // r3.w <- lightVectorLength

#line 491
  div r13.xyz, r13.xyzx, r3.wwww  // r13.x <- lightVectorNorm.x; r13.y <- lightVectorNorm.y; r13.z <- lightVectorNorm.z

#line 398
  max r3.w, r2.w, l(0.000100)
  div r3.w, l(1.000000, 1.000000, 1.000000, 1.000000), r3.w  // r3.w <- attenuation

#line 303
  mul r2.w, r13.w, r2.w  // r2.w <- factor

#line 304
  mad r2.w, -r2.w, r2.w, l(1.000000)
  max r2.w, r2.w, l(0.000000)  // r2.w <- smoothFactor

#line 305
  mul r2.w, r2.w, r2.w  // r2.w <- <SmoothDistanceAttenuation_id79 return value>

#line 399
  mul r2.w, r2.w, r3.w  // r2.w <- attenuation

#line 844
  dp3 r3.w, r6.xyzx, r13.xyzx
  max r3.w, r3.w, l(0.000100)  // r3.w <- streams.NdotL_id49

#line 846
  mul r14.xyz, r2.wwww, r14.xyzx
  mul r14.xyz, r3.wwww, r14.xyzx  // r14.x <- streams.lightColorNdotL_id44.x; r14.y <- streams.lightColorNdotL_id44.y; r14.z <- streams.lightColorNdotL_id44.z

#line 880
  mov r8.xy, r7.zwzz
  add r8.xyw, r13.xyxz, r8.xyxz
  dp3 r2.w, r8.xywx, r8.xywx
  rsq r2.w, r2.w
  mul r8.xyw, r2.wwww, r8.xyxw  // r8.x <- streams.H_id75.x; r8.y <- streams.H_id75.y; r8.w <- streams.H_id75.z

#line 881
  dp3_sat r2.w, r6.xyzx, r8.xywx  // r2.w <- streams.NdotH_id76

#line 882
  dp3_sat r4.w, r13.xyzx, r8.xywx  // r4.w <- streams.LdotH_id77

#line 876
  mul r8.xyw, r9.xyxz, r14.xyxz

#line 1013
  mad r8.xyw, r8.xyxw, l(0.318310, 0.318310, 0.000000, 0.318310), r11.xyxz  // r8.x <- directLightingContribution.x; r8.y <- directLightingContribution.y; r8.w <- directLightingContribution.z

#line 502
  add r13.xyz, -r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r4.w, -r4.w, l(1.000000)
  mul r9.w, r4.w, r4.w
  mul r9.w, r9.w, r9.w
  mul r4.w, r4.w, r9.w
  mad r13.xyz, r13.xyzx, r4.wwww, r10.xyzx  // r13.x <- <FresnelSchlick_id140 return value>.x; r13.y <- <FresnelSchlick_id140 return value>.y; r13.z <- <FresnelSchlick_id140 return value>.z

#line 497
  mul r4.w, r10.w, l(0.500000)  // r4.w <- k

#line 498
  mad r9.w, -r10.w, l(0.500000), l(1.000000)
  mad r11.w, r3.w, r9.w, r4.w
  div r11.w, r3.w, r11.w  // r11.w <- <VisibilityhSchlickGGX_id156 return value>
  mad r4.w, r5.w, r9.w, r4.w
  div r4.w, r5.w, r4.w  // r4.w <- <VisibilityhSchlickGGX_id156 return value>

#line 575
  mul r4.w, r4.w, r11.w
  mul r3.w, r5.w, r3.w
  div r3.w, r4.w, r3.w  // r3.w <- <VisibilitySmithSchlickGGX_id158 return value>

#line 569
  mul r4.w, r10.w, r10.w  // r4.w <- alphaR2

#line 570
  mul r2.w, r2.w, r2.w
  mad r9.w, r10.w, r10.w, l(-1.000000)
  mad r2.w, r2.w, r9.w, l(1.000000)
  max r2.w, r2.w, l(0.000100)  // r2.w <- d

#line 571
  mul r2.w, r2.w, r2.w
  mul r2.w, r2.w, l(3.141593)
  div r2.w, r4.w, r2.w  // r2.w <- <NormalDistributionGGX_id170 return value>

#line 870
  mul r13.xyz, r3.wwww, r13.xyzx
  mul r13.xyz, r2.wwww, r13.xyzx
  mul r13.xyz, r14.xyzx, r13.xyzx

#line 1017
  mad r11.xyz, r13.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r8.xywx  // r11.x <- directLightingContribution.x; r11.y <- directLightingContribution.y; r11.z <- directLightingContribution.z

#line 1003
  iadd r1.w, r1.w, l(1)

#line 1019
endloop   // r5.z <- streams.lightIndex_id174

#line 836
ushr r0.x, r0.y, l(16)  // r0.x <- <GetMaxLightCount_id223 return value>

#line 1027
mov r6.xyz, r1.xyzx
mov r6.w, v0.x
mov r7.xy, v0.yzyy
mov r7.zw, r2.xxxy
mov r8.z, r2.z
mov r9.xyz, r4.xyzx
mov r10.xyz, r3.xyzx
mov r12.x, r0.z  // r12.x <- streams.alphaRoughness_id70
mov r12.z, r5.y  // r12.z <- streams.NdotV_id72
mov r13.xyz, r11.xyzx  // r13.x <- directLightingContribution.x; r13.y <- directLightingContribution.y; r13.z <- directLightingContribution.z
mov r0.y, r5.z  // r0.y <- streams.lightIndex_id174
mov r0.w, l(0)  // r0.w <- i
loop 
  ige r1.w, r0.w, r0.x
  breakc_nz r1.w

#line 1029
  if_nz r1.w

#line 1031
    break 

#line 1032
  endif 

#line 657
  ld_indexable(buffer)(uint,uint,uint,uint) r1.w, r0.yyyy, t3.yzwx  // r1.w <- realLightIndex

#line 658
  iadd r0.y, r0.y, l(1)  // r0.y <- streams.lightIndex_id174

#line 660
  ishl r2.w, r1.w, l(2)
  ld_indexable(buffer)(float,float,float,float) r14.xyz, r2.wwww, t5.xyzw  // r14.x <- spotLight1.x; r14.y <- spotLight1.y; r14.z <- spotLight1.z

#line 663
  bfi r15.xyz, l(30, 30, 30, 0), l(2, 2, 2, 0), r1.wwww, l(1, 2, 3, 0)

#line 661
  ld_indexable(buffer)(float,float,float,float) r16.xyz, r15.xxxx, t5.xyzw  // r16.x <- spotLight2.x; r16.y <- spotLight2.y; r16.z <- spotLight2.z

#line 662
  ld_indexable(buffer)(float,float,float,float) r15.xyw, r15.yyyy, t5.xywz  // r15.x <- spotLight3.x; r15.y <- spotLight3.y; r15.w <- spotLight3.z

#line 663
  ld_indexable(buffer)(float,float,float,float) r17.xyz, r15.zzzz, t5.xyzw  // r17.x <- spotLight4.x; r17.y <- spotLight4.y; r17.z <- spotLight4.z

#line 476
  mov r18.x, r6.w
  mov r18.yz, r7.xxyx
  add r14.xyz, r14.xyzx, -r18.xyzx  // r14.x <- lightVector.x; r14.y <- lightVector.y; r14.z <- lightVector.z

#line 477
  dp3 r1.w, r14.xyzx, r14.xyzx
  sqrt r2.w, r1.w  // r2.w <- lightVectorLength

#line 478
  div r14.xyz, r14.xyzx, r2.wwww  // r14.x <- lightVectorNorm.x; r14.y <- lightVectorNorm.y; r14.z <- lightVectorNorm.z

#line 391
  max r2.w, r1.w, l(0.000100)
  div r2.w, l(1.000000, 1.000000, 1.000000, 1.000000), r2.w  // r2.w <- attenuation

#line 297
  mul r1.w, r15.w, r1.w  // r1.w <- factor

#line 298
  mad r1.w, -r1.w, r1.w, l(1.000000)
  max r1.w, r1.w, l(0.000000)  // r1.w <- smoothFactor

#line 299
  mul r1.w, r1.w, r1.w  // r1.w <- <SmoothDistanceAttenuation_id90 return value>

#line 392
  mul r1.w, r1.w, r2.w  // r1.w <- attenuation

#line 383
  dp3 r2.w, -r16.xyzx, r14.xyzx  // r2.w <- cd

#line 384
  mad_sat r2.w, r2.w, r15.x, r15.y  // r2.w <- attenuation

#line 385
  mul r2.w, r2.w, r2.w

#line 484
  mul r1.w, r1.w, r2.w  // r1.w <- attenuation

#line 822
  dp3 r2.w, r6.xyzx, r14.xyzx
  max r2.w, r2.w, l(0.000100)  // r2.w <- streams.NdotL_id49

#line 824
  mul r15.xyz, r1.wwww, r17.xyzx
  mul r15.xyz, r2.wwww, r15.xyzx  // r15.x <- streams.lightColorNdotL_id44.x; r15.y <- streams.lightColorNdotL_id44.y; r15.z <- streams.lightColorNdotL_id44.z

#line 880
  mov r8.xy, r7.zwzz
  add r8.xyw, r14.xyxz, r8.xyxz
  dp3 r1.w, r8.xywx, r8.xywx
  rsq r1.w, r1.w
  mul r8.xyw, r1.wwww, r8.xyxw  // r8.x <- streams.H_id75.x; r8.y <- streams.H_id75.y; r8.w <- streams.H_id75.z

#line 881
  dp3_sat r1.w, r6.xyzx, r8.xywx  // r1.w <- streams.NdotH_id76

#line 882
  dp3_sat r3.w, r14.xyzx, r8.xywx  // r3.w <- streams.LdotH_id77

#line 876
  mul r8.xyw, r9.xyxz, r15.xyxz

#line 1037
  mad r8.xyw, r8.xyxw, l(0.318310, 0.318310, 0.000000, 0.318310), r13.xyxz  // r8.x <- directLightingContribution.x; r8.y <- directLightingContribution.y; r8.w <- directLightingContribution.z

#line 502
  add r14.xyz, -r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r3.w, -r3.w, l(1.000000)
  mul r4.w, r3.w, r3.w
  mul r4.w, r4.w, r4.w
  mul r3.w, r3.w, r4.w
  mad r14.xyz, r14.xyzx, r3.wwww, r10.xyzx  // r14.x <- <FresnelSchlick_id140 return value>.x; r14.y <- <FresnelSchlick_id140 return value>.y; r14.z <- <FresnelSchlick_id140 return value>.z

#line 497
  mul r3.w, r12.x, l(0.500000)  // r3.w <- k

#line 498
  mad r4.w, -r12.x, l(0.500000), l(1.000000)
  mad r5.w, r2.w, r4.w, r3.w
  div r5.w, r2.w, r5.w  // r5.w <- <VisibilityhSchlickGGX_id156 return value>
  mad r3.w, r12.z, r4.w, r3.w
  div r3.w, r12.z, r3.w  // r3.w <- <VisibilityhSchlickGGX_id156 return value>

#line 575
  mul r3.w, r3.w, r5.w
  mul r2.w, r12.z, r2.w
  div r2.w, r3.w, r2.w  // r2.w <- <VisibilitySmithSchlickGGX_id158 return value>

#line 569
  mul r3.w, r12.x, r12.x  // r3.w <- alphaR2

#line 570
  mul r1.w, r1.w, r1.w
  mad r4.w, r12.x, r12.x, l(-1.000000)
  mad r1.w, r1.w, r4.w, l(1.000000)
  max r1.w, r1.w, l(0.000100)  // r1.w <- d

#line 571
  mul r1.w, r1.w, r1.w
  mul r1.w, r1.w, l(3.141593)
  div r1.w, r3.w, r1.w  // r1.w <- <NormalDistributionGGX_id170 return value>

#line 870
  mul r14.xyz, r2.wwww, r14.xyzx
  mul r14.xyz, r1.wwww, r14.xyzx
  mul r14.xyz, r15.xyzx, r14.xyzx

#line 1041
  mad r13.xyz, r14.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r8.xywx  // r13.x <- directLightingContribution.x; r13.y <- directLightingContribution.y; r13.z <- directLightingContribution.z

#line 1027
  iadd r0.w, r0.w, l(1)

#line 1043
endloop   // r0.y <- streams.lightIndex_id174

#line 633
sqrt r0.x, r0.z
add r5.x, -r0.x, l(1.000000)  // r5.x <- glossiness

#line 634
sample_l_indexable(texture2d)(float,float,float,float) r0.xy, r5.xyxx, t0.xyzw, s0, l(0.000000)  // r0.x <- environmentLightingDFG.x; r0.y <- environmentLightingDFG.y

#line 635
mad r0.xyz, r3.xyzx, r0.xxxx, r0.yyyy  // r0.x <- <Compute_id269 return value>.x; r0.y <- <Compute_id269 return value>.y; r0.z <- <Compute_id269 return value>.z

#line 805
mul r0.xyz, r0.xyzx, cb2[148].xyzx  // r0.x <- <ComputeEnvironmentLightContribution_id448 return value>.x; r0.y <- <ComputeEnvironmentLightContribution_id448 return value>.y; r0.z <- <ComputeEnvironmentLightContribution_id448 return value>.z

#line 1055
mad r0.xyz, r4.xyzx, cb2[148].xyzx, r0.xyzx  // r0.x <- environmentLightingContribution.x; r0.y <- environmentLightingContribution.y; r0.z <- environmentLightingContribution.z

#line 1070
mad o0.xyz, r13.xyzx, l(3.141593, 3.141593, 3.141593, 0.000000), r0.xyzx

#line 1177
utof o1.xyzw, cb0[26].xxxx

#line 1245
mov o0.w, cb1[0].w
ret 
// Approximately 415 instruction slots used
***************************
*************************/
const static int TMaxLightCount_id87 = 2;
const static int TCascadeCountBase_id151 = 4;
const static int TLightCountBase_id152 = 2;
const static int TCascadeCount_id159 = 4;
const static int TLightCount_id160 = 2;
const static bool TBlendCascades_id161 = true;
const static bool TDepthRangeAuto_id162 = true;
const static bool TCascadeDebug_id163 = false;
const static bool TComputeTransmittance_id164 = false;
const static int TFilterSize_id166 = 5;
const static bool TInvert_id198 = true;
const static bool TIsEnergyConservative_id210 = false;
static const float PI_id212 = 3.14159265358979323846;
struct PS_STREAMS 
{
    float4 ScreenPosition_id167;
    float3 normalWS_id19;
    float4 PositionWS_id22;
    float DepthVS_id23;
    float4 ShadingPosition_id0;
    bool IsFrontFace_id1;
    float3 meshNormalWS_id17;
    float3 viewWS_id68;
    float3 shadingColor_id73;
    float matBlend_id40;
    float3 matNormal_id51;
    float4 matColorBase_id52;
    float4 matDiffuse_id53;
    float3 matDiffuseVisible_id69;
    float3 matSpecular_id55;
    float3 matSpecularVisible_id71;
    float matSpecularIntensity_id56;
    float matGlossiness_id54;
    float alphaRoughness_id70;
    float matAmbientOcclusion_id57;
    float matAmbientOcclusionDirectLightingFactor_id58;
    float matCavity_id59;
    float matCavityDiffuse_id60;
    float matCavitySpecular_id61;
    float4 matEmissive_id62;
    float matEmissiveIntensity_id63;
    float matScatteringStrength_id64;
    float2 matDiffuseSpecularAlphaBlend_id65;
    float3 matAlphaBlendColor_id66;
    float matAlphaDiscard_id67;
    float shadingColorAlpha_id74;
    float4 Input_0_id183;
    float Input_1_id191;
    float Input_2_id200;
    float3 lightPositionWS_id41;
    float3 lightDirectionWS_id42;
    float3 lightColor_id43;
    float3 lightColorNdotL_id44;
    float3 lightSpecularColorNdotL_id45;
    float lightAttenuation_id46;
    float3 envLightDiffuseColor_id47;
    float3 envLightSpecularColor_id48;
    float lightDirectAmbientOcclusion_id50;
    float NdotL_id49;
    float NdotV_id72;
    float thicknessWS_id85;
    float3 shadowColor_id84;
    float3 H_id75;
    float NdotH_id76;
    float LdotH_id77;
    float VdotH_id78;
    uint2 lightData_id173;
    int lightIndex_id174;
    float4 ColorTarget_id2;
    float4 ColorTarget1_id3;
};
struct PS_OUTPUT 
{
    float4 ColorTarget_id2 : SV_Target0;
    float4 ColorTarget1_id3 : SV_Target1;
};
struct PS_INPUT 
{
    float4 PositionWS_id22 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float DepthVS_id23 : DEPTH_VS;
    float3 normalWS_id19 : NORMALWS;
    float4 ScreenPosition_id167 : SCREENPOSITION_ID167_SEM;
    bool IsFrontFace_id1 : SV_IsFrontFace;
};
struct VS_STREAMS 
{
    float4 Position_id21;
    float3 meshNormal_id16;
    float4 PositionH_id24;
    float3 meshNormalWS_id17;
    float4 PositionWS_id22;
    float4 ShadingPosition_id0;
    float DepthVS_id23;
    float3 normalWS_id19;
    float4 ScreenPosition_id167;
};
struct VS_OUTPUT 
{
    float4 PositionWS_id22 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float DepthVS_id23 : DEPTH_VS;
    float3 normalWS_id19 : NORMALWS;
    float4 ScreenPosition_id167 : SCREENPOSITION_ID167_SEM;
};
struct VS_INPUT 
{
    float4 Position_id21 : POSITION;
    float3 meshNormal_id16 : NORMAL;
};
struct DirectionalLightData 
{
    float3 DirectionWS;
    float3 Color;
};
struct PointLightData 
{
    float3 PositionWS;
    float InvSquareRadius;
    float3 Color;
};
struct PointLightDataInternal 
{
    float3 PositionWS;
    float InvSquareRadius;
    float3 Color;
};
struct SpotLightDataInternal 
{
    float3 PositionWS;
    float3 DirectionWS;
    float3 AngleOffsetAndInvSquareRadius;
    float3 Color;
};
struct SpotLightData 
{
    float3 PositionWS;
    float3 DirectionWS;
    float3 AngleOffsetAndInvSquareRadius;
    float3 Color;
};
cbuffer PerDraw 
{
    float4x4 World_id32;
    float4x4 WorldInverse_id33;
    float4x4 WorldInverseTranspose_id34;
    float4x4 WorldView_id35;
    float4x4 WorldViewInverse_id36;
    float4x4 WorldViewProjection_id37;
    float3 WorldScale_id38;
    float4 EyeMS_id39;
    uint MaterialIndex_id83;
};
cbuffer PerMaterial 
{
    float4 InputValue_id184;
    float InputValue_id192;
    float InputValue_id201;
};
cbuffer PerView 
{
    float4x4 View_id25;
    float4x4 ViewInverse_id26;
    float4x4 Projection_id27;
    float4x4 ProjectionInverse_id28;
    float4x4 ViewProjection_id29;
    float2 ProjScreenRay_id30;
    float4 Eye_id31;
    float NearClipPlane_id168 = 1.0f;
    float FarClipPlane_id169 = 100.0f;
    float2 ZProjection_id170;
    float2 ViewSize_id171;
    float AspectRatio_id172;
    float4 _padding_PerView_Default;
    int LightCount_id86;
    DirectionalLightData Lights_id88[TMaxLightCount_id87];
    float2 ShadowMapTextureSize_id90;
    float2 ShadowMapTextureTexelSize_id91;
    float4x4 WorldToShadowCascadeUV_id153[TCascadeCountBase_id151 * TLightCountBase_id152];
    float4x4 InverseWorldToShadowCascadeUV_id154[TCascadeCountBase_id151 * TLightCountBase_id152];
    float4x4 ViewMatrices_id155[TCascadeCountBase_id151 * TLightCountBase_id152];
    float2 DepthRanges_id156[TCascadeCountBase_id151 * TLightCountBase_id152];
    float DepthBiases_id157[TLightCountBase_id152];
    float OffsetScales_id158[TLightCountBase_id152];
    float CascadeDepthSplits_id165[TCascadeCount_id159 * TLightCount_id160];
    float ClusterDepthScale_id177;
    float ClusterDepthBias_id178;
    float2 ClusterStride_id179;
    float3 AmbientLight_id182;
    float4 _padding_PerView_Lighting;
};
cbuffer Globals 
{
    float2 Texture0TexelSize_id93;
    float2 Texture1TexelSize_id95;
    float2 Texture2TexelSize_id97;
    float2 Texture3TexelSize_id99;
    float2 Texture4TexelSize_id101;
    float2 Texture5TexelSize_id103;
    float2 Texture6TexelSize_id105;
    float2 Texture7TexelSize_id107;
    float2 Texture8TexelSize_id109;
    float2 Texture9TexelSize_id111;
};
Texture2D Texture0_id92;
Texture2D Texture1_id94;
Texture2D Texture2_id96;
Texture2D Texture3_id98;
Texture2D Texture4_id100;
Texture2D Texture5_id102;
Texture2D Texture6_id104;
Texture2D Texture7_id106;
Texture2D Texture8_id108;
Texture2D Texture9_id110;
TextureCube TextureCube0_id112;
TextureCube TextureCube1_id113;
TextureCube TextureCube2_id114;
TextureCube TextureCube3_id115;
Texture3D Texture3D0_id116;
Texture3D Texture3D1_id117;
Texture3D Texture3D2_id118;
Texture3D Texture3D3_id119;
SamplerState Sampler_id120;
SamplerState PointSampler_id121 
{
    Filter = MIN_MAG_MIP_POINT;
};
SamplerState LinearSampler_id122 
{
    Filter = MIN_MAG_MIP_LINEAR;
};
SamplerState LinearBorderSampler_id123 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Border;
    AddressV = Border;
};
SamplerComparisonState LinearClampCompareLessEqualSampler_id124 
{
    Filter = COMPARISON_MIN_MAG_LINEAR_MIP_POINT;
    AddressU = Clamp;
    AddressV = Clamp;
    ComparisonFunc = LessEqual;
};
SamplerState AnisotropicSampler_id125 
{
    Filter = ANISOTROPIC;
};
SamplerState AnisotropicRepeatSampler_id126 
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
    MaxAnisotropy = 16;
};
SamplerState PointRepeatSampler_id127 
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState LinearRepeatSampler_id128 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState RepeatSampler_id129 
{
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState Sampler0_id130;
SamplerState Sampler1_id131;
SamplerState Sampler2_id132;
SamplerState Sampler3_id133;
SamplerState Sampler4_id134;
SamplerState Sampler5_id135;
SamplerState Sampler6_id136;
SamplerState Sampler7_id137;
SamplerState Sampler8_id138;
SamplerState Sampler9_id139;
Texture2D EnvironmentLightingDFG_LUT_id213;
Texture2D ShadowMapTexture_id89;
Texture3D<uint2> LightClusters_id175;
Buffer<uint> LightIndices_id176;
Buffer<float4> PointLights_id180;
Buffer<float4> SpotLights_id181;
float4 Project_id57(float4 vec, float4x4 mat)
{
    float4 vecProjected = mul(vec, mat);
    vecProjected.xyz /= vecProjected.w;
    return vecProjected;
}
float SmoothDistanceAttenuation_id90(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float SmoothDistanceAttenuation_id79(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float Get3x3FilterKernel_id67(float2 base_uv, float2 st, out float3 kernel[4])
{
    float2 uvW0 = (3 - 2 * st);
    float2 uvW1 = (1 + 2 * st);
    float2 uv0 = (2 - st) / uvW0 - 1;
    float2 uv1 = st / uvW1 + 1;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id91, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id91, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id91, uvW0.x * uvW1.y);
    kernel[3] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id91, uvW1.x * uvW1.y);
    return 16.0;
}
float Get5x5FilterKernel_id66(float2 base_uv, float2 st, out float3 kernel[9])
{
    float2 uvW0 = (4 - 3 * st);
    float2 uvW1 = 7;
    float2 uvW2 = (1 + 3 * st);
    float2 uv0 = (3 - 2 * st) / uvW0 - 2;
    float2 uv1 = (3 + st) / uvW1;
    float2 uv2 = st / uvW2 + 2;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id91, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id91, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv2.x, uv0.y) * ShadowMapTextureTexelSize_id91, uvW2.x * uvW0.y);
    kernel[3] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id91, uvW0.x * uvW1.y);
    kernel[4] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id91, uvW1.x * uvW1.y);
    kernel[5] = float3(base_uv + float2(uv2.x, uv1.y) * ShadowMapTextureTexelSize_id91, uvW2.x * uvW1.y);
    kernel[6] = float3(base_uv + float2(uv0.x, uv2.y) * ShadowMapTextureTexelSize_id91, uvW0.x * uvW2.y);
    kernel[7] = float3(base_uv + float2(uv1.x, uv2.y) * ShadowMapTextureTexelSize_id91, uvW1.x * uvW2.y);
    kernel[8] = float3(base_uv + uv2 * ShadowMapTextureTexelSize_id91, uvW2.x * uvW2.y);
    return 144.0;
}
float SampleThickness_id68(float3 shadowSpaceCoordinate, float3 pixelPositionWS, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float shadowMapDepth = ShadowMapTexture_id89.SampleLevel(LinearBorderSampler_id123, shadowSpaceCoordinate.xy, 0).r;
    float thickness;
    if (isOrthographic)
    {
        thickness = abs(shadowMapDepth - shadowSpaceCoordinate.z) * depthRanges.y;
    }
    else
    {
        float4 shadowmapPositionWorldSpace = Project_id57(float4(shadowSpaceCoordinate.xy, shadowMapDepth, 1.0), inverseWorldToShadowCascadeUV);
        thickness = distance(shadowmapPositionWorldSpace.xyz, pixelPositionWS.xyz);
    }
    return (thickness);
}
float Get7x7FilterKernel_id64(float2 base_uv, float2 st, out float3 kernel[16])
{
    float2 uvW0 = (5 * st - 6);
    float2 uvW1 = (11 * st - 28);
    float2 uvW2 = -(11 * st + 17);
    float2 uvW3 = -(5 * st + 1);
    float2 uv0 = (4 * st - 5) / uvW0 - 3;
    float2 uv1 = (4 * st - 16) / uvW1 - 1;
    float2 uv2 = -(7 * st + 5) / uvW2 + 1;
    float2 uv3 = -st / uvW3 + 3;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id91, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id91, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv2.x, uv0.y) * ShadowMapTextureTexelSize_id91, uvW2.x * uvW0.y);
    kernel[3] = float3(base_uv + float2(uv3.x, uv0.y) * ShadowMapTextureTexelSize_id91, uvW3.x * uvW0.y);
    kernel[4] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id91, uvW0.x * uvW1.y);
    kernel[5] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id91, uvW1.x * uvW1.y);
    kernel[6] = float3(base_uv + float2(uv2.x, uv1.y) * ShadowMapTextureTexelSize_id91, uvW2.x * uvW1.y);
    kernel[7] = float3(base_uv + float2(uv3.x, uv1.y) * ShadowMapTextureTexelSize_id91, uvW3.x * uvW1.y);
    kernel[8] = float3(base_uv + float2(uv0.x, uv2.y) * ShadowMapTextureTexelSize_id91, uvW0.x * uvW2.y);
    kernel[9] = float3(base_uv + float2(uv1.x, uv2.y) * ShadowMapTextureTexelSize_id91, uvW1.x * uvW2.y);
    kernel[10] = float3(base_uv + uv2 * ShadowMapTextureTexelSize_id91, uvW2.x * uvW2.y);
    kernel[11] = float3(base_uv + float2(uv3.x, uv2.y) * ShadowMapTextureTexelSize_id91, uvW3.x * uvW2.y);
    kernel[12] = float3(base_uv + float2(uv0.x, uv3.y) * ShadowMapTextureTexelSize_id91, uvW0.x * uvW3.y);
    kernel[13] = float3(base_uv + float2(uv1.x, uv3.y) * ShadowMapTextureTexelSize_id91, uvW1.x * uvW3.y);
    kernel[14] = float3(base_uv + float2(uv2.x, uv3.y) * ShadowMapTextureTexelSize_id91, uvW2.x * uvW3.y);
    kernel[15] = float3(base_uv + uv3 * ShadowMapTextureTexelSize_id91, uvW3.x * uvW3.y);
    return 2704.0;
}
float GetAngularAttenuation_id92(float3 lightVector, float3 lightDirection, float lightAngleScale, float lightAngleOffset)
{
    float cd = dot(lightDirection, lightVector);
    float attenuation = saturate(cd * lightAngleScale + lightAngleOffset);
    attenuation *= attenuation;
    return attenuation;
}
float GetDistanceAttenuation_id91(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id90(d2, lightInvSquareRadius);
    return attenuation;
}
float GetDistanceAttenuation_id81(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id79(d2, lightInvSquareRadius);
    return attenuation;
}
float SampleAndFilter_id72(float3 adjustedPixelPositionWS, float3 adjustedPixelPositionShadowSpace, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic, bool isDualParaboloid = false)
{
    float2 uv = adjustedPixelPositionShadowSpace.xy * ShadowMapTextureSize_id90;
    float2 base_uv = floor(uv + 0.5);
    float2 st = uv + 0.5 - base_uv;
    base_uv *= ShadowMapTextureTexelSize_id91;
    float thickness = 0.0;
    float normalizationFactor = 1.0;

    {
        float3 kernel[9];
        normalizationFactor = Get5x5FilterKernel_id66(base_uv, st, kernel);

        [unroll]
        for (int i = 0; i < 9; ++i)
        {
            thickness += kernel[i].z * SampleThickness_id68(float3(kernel[i].xy, adjustedPixelPositionShadowSpace.z), adjustedPixelPositionWS, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
        }
    }
    return (thickness / normalizationFactor);
}
void CalculateAdjustedShadowSpacePixelPosition_id71(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    float4 bottomLeftTexelWS = Project_id57(float4(0.0, 0.0, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id57(float4(ShadowMapTextureTexelSize_id91.xy * filterRadiusInPixels, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, bottomLeftTexelWS.xyz);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 shadowMapCoordinate = Project_id57(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = shadowMapCoordinate.xyz;
}
void CalculateAdjustedShadowSpacePixelPositionPerspective_id70(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    const float4 shadowMapCoordinate = Project_id57(float4(pixelPositionWS, 1.0), worldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id57(float4(shadowMapCoordinate.xy + ShadowMapTextureTexelSize_id91.xy * filterRadiusInPixels, shadowMapCoordinate.z, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, pixelPositionWS);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 adjustedShadowMapCoordinate = Project_id57(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = adjustedShadowMapCoordinate.xyz;
}
float GetFilterRadiusInPixels_id69()
{

    {
        return 3.5;
    }
}
float SampleTextureAndCompare_id65(float2 position, float positionDepth)
{
    return ShadowMapTexture_id89.SampleCmpLevelZero(LinearClampCompareLessEqualSampler_id124, position, positionDepth);
}
void CalculatePCFKernelParameters_id63(float2 position, out float2 base_uv, out float2 st)
{
    float2 uv = position * ShadowMapTextureSize_id90;
    base_uv = floor(uv + 0.5);
    st = uv + 0.5 - base_uv;
    base_uv -= 0.5;
    base_uv *= ShadowMapTextureTexelSize_id91;
}
float Compute_id257()
{
    return InputValue_id201;
}
float Compute_id245()
{
    return InputValue_id192;
}
float4 Compute_id233()
{
    return InputValue_id184;
}
float ComputeAttenuation_id93(float3 PositionWS, float3 AngleOffsetAndInvSquareRadius, float3 DirectionWS, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float3 lightAngleOffsetAndInvSquareRadius = AngleOffsetAndInvSquareRadius;
    float2 lightAngleAndOffset = lightAngleOffsetAndInvSquareRadius.xy;
    float lightInvSquareRadius = lightAngleOffsetAndInvSquareRadius.z;
    float3 lightDirection = -DirectionWS;
    float attenuation = GetDistanceAttenuation_id91(lightVectorLength, lightInvSquareRadius);
    attenuation *= GetAngularAttenuation_id92(lightVectorNorm, lightDirection, lightAngleAndOffset.x, lightAngleAndOffset.y);
    return attenuation;
}
float ComputeAttenuation_id80(PointLightDataInternal light, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = light.PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float lightInvSquareRadius = light.InvSquareRadius;
    return GetDistanceAttenuation_id81(lightVectorLength, lightInvSquareRadius);
}
float VisibilityhSchlickGGX_id156(float alphaR, float nDotX)
{
    float k = alphaR * 0.5f;
    return nDotX / (nDotX * (1.0f - k) + k);
}
float3 FresnelSchlick_id140(float3 f0, float3 f90, float lOrVDotH)
{
    return f0 + (f90 - f0) * pow((1 - lOrVDotH), 5);
}
float FilterThickness_id59(float3 pixelPositionWS, float3 meshNormalWS, float2 depthRanges, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    float3 adjustedPixelPositionWS;
    float3 adjustedPixelPositionShadowSpace;
    if (isOrthographic)
    {
        CalculateAdjustedShadowSpacePixelPosition_id71(GetFilterRadiusInPixels_id69(), pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    else
    {
        CalculateAdjustedShadowSpacePixelPositionPerspective_id70(GetFilterRadiusInPixels_id69(), pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    return SampleAndFilter_id72(adjustedPixelPositionWS, adjustedPixelPositionShadowSpace, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
}
float FilterShadow_id58(float2 position, float positionDepth)
{
    float shadow = 0.0f;
    float2 base_uv;
    float2 st;
    CalculatePCFKernelParameters_id63(position, base_uv, st);

    {
        float3 kernel[9];
        float normalizationFactor = Get5x5FilterKernel_id66(base_uv, st, kernel);

        [unroll]
        for (int i = 0; i < 9; ++i)
        {
            shadow += kernel[i].z * SampleTextureAndCompare_id65(kernel[i].xy, positionDepth);
        }
        shadow /= normalizationFactor;
    }
    return shadow;
}
void Compute_id260(inout PS_STREAMS streams)
{
    streams.Input_2_id200 = Compute_id257();
}
void Compute_id248(inout PS_STREAMS streams)
{
    streams.Input_1_id191 = Compute_id245();
}
void Compute_id236(inout PS_STREAMS streams)
{
    streams.Input_0_id183 = Compute_id233();
}
void ProcessLight_id94(inout PS_STREAMS streams, SpotLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id93(light.PositionWS, light.AngleOffsetAndInvSquareRadius, light.DirectionWS, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
void ProcessLight_id83(inout PS_STREAMS streams, PointLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id80(light, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightPositionWS_id41 = light.PositionWS;
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
float NormalDistributionGGX_id170(float alphaR, float nDotH)
{
    float alphaR2 = alphaR * alphaR;
    float d = max(nDotH * nDotH * (alphaR2 - 1) + 1, 0.0001);
    return alphaR2 / (PI_id212 * d * d);
}
float VisibilitySmithSchlickGGX_id158(float alphaR, float nDotL, float nDotV)
{
    return VisibilityhSchlickGGX_id156(alphaR, nDotL) * VisibilityhSchlickGGX_id156(alphaR, nDotV) / (nDotL * nDotV);
}
float3 FresnelSchlick_id146(float3 f0, float lOrVDotH)
{
    return FresnelSchlick_id140(f0, 1.0f, lOrVDotH);
}
float ComputeThicknessFromCascade_id62(float3 pixelPositionWS, float3 meshNormalWS, int cascadeIndex, int lightIndex, bool isOrthographic)
{
    const int arrayIndex = cascadeIndex + lightIndex * TCascadeCountBase_id151;
    return FilterThickness_id59(pixelPositionWS, meshNormalWS, DepthRanges_id156[arrayIndex], WorldToShadowCascadeUV_id153[arrayIndex], InverseWorldToShadowCascadeUV_id154[arrayIndex], isOrthographic);
}
float ComputeShadowFromCascade_id61(float3 shadowPositionWS, int cascadeIndex, int lightIndex)
{
    float4 shadowPosition = mul(float4(shadowPositionWS, 1.0), WorldToShadowCascadeUV_id153[cascadeIndex + lightIndex * TCascadeCountBase_id151]);
    shadowPosition.z -= DepthBiases_id157[lightIndex];
    shadowPosition.xyz /= shadowPosition.w;
    return FilterShadow_id58(shadowPosition.xy, shadowPosition.z);
}
float3 GetShadowPositionOffset_id60(float offsetScale, float nDotL, float3 normal)
{
    float normalOffsetScale = saturate(1.0f - nDotL);
    return 2.0f * ShadowMapTextureTexelSize_id91.x * offsetScale * normalOffsetScale * normal;
}
float Compute_id263(inout PS_STREAMS streams)
{
    return streams.Input_2_id200;
}
void Compute_id262(inout PS_STREAMS streams)
{

    {
        Compute_id260(streams);
    }
}
float Compute_id251(inout PS_STREAMS streams)
{
    return streams.Input_1_id191;
}
void Compute_id250(inout PS_STREAMS streams)
{

    {
        Compute_id248(streams);
    }
}
float4 Compute_id239(inout PS_STREAMS streams)
{
    return streams.Input_0_id183;
}
void Compute_id238(inout PS_STREAMS streams)
{

    {
        Compute_id236(streams);
    }
}
float3 Compute_id269(float3 specularColor, float alphaR, float nDotV)
{
    float glossiness = 1.0f - sqrt(alphaR);
    float4 environmentLightingDFG = EnvironmentLightingDFG_LUT_id213.SampleLevel(LinearSampler_id122, float2(glossiness, nDotV), 0);
    return specularColor * environmentLightingDFG.r + environmentLightingDFG.g;
}
void PrepareEnvironmentLight_id98(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeSpecularTextureProjection_id89(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id88(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id87(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id86(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id176.Load(streams.lightIndex_id174);
    streams.lightIndex_id174++;
    SpotLightDataInternal spotLight;
    float4 spotLight1 = SpotLights_id181.Load(realLightIndex * 4);
    float4 spotLight2 = SpotLights_id181.Load(realLightIndex * 4 + 1);
    float4 spotLight3 = SpotLights_id181.Load(realLightIndex * 4 + 2);
    float4 spotLight4 = SpotLights_id181.Load(realLightIndex * 4 + 3);
    spotLight.PositionWS = spotLight1.xyz;
    spotLight.DirectionWS = spotLight2.xyz;
    spotLight.AngleOffsetAndInvSquareRadius = spotLight3.xyz;
    spotLight.Color = spotLight4.xyz;
    ProcessLight_id94(streams, spotLight);
}
float3 ComputeSpecularTextureProjection_id78(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id77(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id76(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id75(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id176.Load(streams.lightIndex_id174);
    streams.lightIndex_id174++;
    PointLightDataInternal pointLight;
    float4 pointLight1 = PointLights_id180.Load(realLightIndex * 2);
    float4 pointLight2 = PointLights_id180.Load(realLightIndex * 2 + 1);
    pointLight.PositionWS = pointLight1.xyz;
    pointLight.InvSquareRadius = pointLight1.w;
    pointLight.Color = pointLight2.xyz;
    ProcessLight_id83(streams, pointLight);
}
void PrepareLightData_id82(inout PS_STREAMS streams)
{
    float projectedDepth = streams.ShadingPosition_id0.z;
    float depth = ZProjection_id170.y / (projectedDepth - ZProjection_id170.x);
    float2 texCoord = float2(streams.ScreenPosition_id167.x + 1, 1 - streams.ScreenPosition_id167.y) * 0.5;
    int slice = int(max(log2(depth * ClusterDepthScale_id177 + ClusterDepthBias_id178), 0));
    streams.lightData_id173 = LightClusters_id175.Load(int4(texCoord * ClusterStride_id179, slice, 0));
    streams.lightIndex_id174 = streams.lightData_id173.x;
}
float Compute_id361(inout PS_STREAMS streams)
{
    return NormalDistributionGGX_id170(streams.alphaRoughness_id70, streams.NdotH_id76);
}
float Compute_id331(inout PS_STREAMS streams)
{
    return VisibilitySmithSchlickGGX_id158(streams.alphaRoughness_id70, streams.NdotL_id49, streams.NdotV_id72);
}
float3 Compute_id301(inout PS_STREAMS streams, float3 f0)
{
    return FresnelSchlick_id146(f0, streams.LdotH_id77);
}
float3 ComputeSpecularTextureProjection_id54(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id53(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id52(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    int cascadeIndexBase = lightIndex * TCascadeCount_id159;
    int cascadeIndex = 0;

    [unroll]
    for (int i = 0; i < TCascadeCount_id159 - 1; i++)
    {
        [flatten]
        if (streams.DepthVS_id23 > CascadeDepthSplits_id165[cascadeIndexBase + i])
        {
            cascadeIndex = i + 1;
        }
    }
    float3 shadow = 1.0;
    float tempThickness = 999.0;
    float3 shadowPosition = position.xyz;
    shadowPosition += GetShadowPositionOffset_id60(OffsetScales_id158[lightIndex], streams.NdotL_id49, streams.normalWS_id19);
    if (cascadeIndex < TCascadeCount_id159)
    {
        shadow = ComputeShadowFromCascade_id61(shadowPosition, cascadeIndex, lightIndex);
        float nextSplit = CascadeDepthSplits_id165[cascadeIndexBase + cascadeIndex];
        float splitSize = nextSplit;
        if (cascadeIndex > 0)
        {
            splitSize = nextSplit - CascadeDepthSplits_id165[cascadeIndexBase + cascadeIndex - 1];
        }
        float splitDist = (nextSplit - streams.DepthVS_id23) / splitSize;
        if (splitDist < 0.2)
        {
            float lerpAmt = smoothstep(0.0, 0.2, splitDist);
            if (cascadeIndex == TCascadeCount_id159 - 1)
            {
            }
            else if (TBlendCascades_id161)
            {
                float nextShadow = ComputeShadowFromCascade_id61(shadowPosition, cascadeIndex + 1, lightIndex);
                shadow = lerp(nextShadow, shadow, lerpAmt);
            }
        }
    }
    streams.thicknessWS_id85 = tempThickness;
    return shadow;
}
void PrepareDirectLightCore_id51(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id88[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id88[lightIndex].DirectionWS;
}
float Compute_id266(inout PS_STREAMS streams)
{
    Compute_id262(streams);
    return Compute_id263(streams);
}
float Compute_id254(inout PS_STREAMS streams)
{
    Compute_id250(streams);
    return Compute_id251(streams);
}
float4 Compute_id242(inout PS_STREAMS streams)
{
    Compute_id238(streams);
    return Compute_id239(streams);
}
void ResetStream_id173()
{
}
void AfterLightingAndShading_id418()
{
}
void AfterLightingAndShading_id399()
{
}
void PrepareEnvironmentLight_id232(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeEnvironmentLightContribution_id448(inout PS_STREAMS streams)
{
    float3 specularColor = streams.matSpecularVisible_id71;
    return Compute_id269(specularColor, streams.alphaRoughness_id70, streams.NdotV_id72) * streams.envLightSpecularColor_id48;
}
float3 ComputeEnvironmentLightContribution_id392(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor * streams.envLightDiffuseColor_id47;
}
void PrepareEnvironmentLight_id229(inout PS_STREAMS streams)
{
    PrepareEnvironmentLight_id98(streams);
    float3 lightColor = AmbientLight_id182 * streams.matAmbientOcclusion_id57;
    streams.envLightDiffuseColor_id47 = lightColor;
    streams.envLightSpecularColor_id48 = lightColor;
}
void PrepareDirectLight_id220(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id86(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id87(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id88(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id89(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id224(inout PS_STREAMS streams)
{
    return streams.lightData_id173.y >> 16;
}
int GetMaxLightCount_id223(inout PS_STREAMS streams)
{
    return streams.lightData_id173.y >> 16;
}
void PrepareDirectLights_id218()
{
}
void PrepareDirectLight_id207(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id75(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id76(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id77(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id78(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id212(inout PS_STREAMS streams)
{
    return streams.lightData_id173.y & 0xFFFF;
}
int GetMaxLightCount_id211(inout PS_STREAMS streams)
{
    return streams.lightData_id173.y & 0xFFFF;
}
void PrepareDirectLights_id210(inout PS_STREAMS streams)
{
    PrepareLightData_id82(streams);
}
float3 ComputeDirectLightContribution_id447(inout PS_STREAMS streams)
{
    float3 specularColor = streams.matSpecularVisible_id71;
    float3 fresnel = Compute_id301(streams, specularColor);
    float geometricShadowing = Compute_id331(streams);
    float normalDistribution = Compute_id361(streams);
    float3 reflected = fresnel * geometricShadowing * normalDistribution / 4;
    return reflected * streams.lightSpecularColorNdotL_id45 * streams.matDiffuseSpecularAlphaBlend_id65.y;
}
float3 ComputeDirectLightContribution_id391(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor / PI_id212 * streams.lightColorNdotL_id44 * streams.matDiffuseSpecularAlphaBlend_id65.x;
}
void PrepareMaterialPerDirectLight_id30(inout PS_STREAMS streams)
{
    streams.H_id75 = normalize(streams.viewWS_id68 + streams.lightDirectionWS_id42);
    streams.NdotH_id76 = saturate(dot(streams.normalWS_id19, streams.H_id75));
    streams.LdotH_id77 = saturate(dot(streams.lightDirectionWS_id42, streams.H_id75));
    streams.VdotH_id78 = streams.LdotH_id77;
}
void PrepareDirectLight_id183(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id51(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id52(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id53(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id54(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id185()
{
    return LightCount_id86;
}
int GetMaxLightCount_id186()
{
    return TMaxLightCount_id87;
}
void PrepareDirectLights_id181()
{
}
void PrepareForLightingAndShading_id415()
{
}
void PrepareForLightingAndShading_id396()
{
}
void PrepareMaterialForLightingAndShading_id172(inout PS_STREAMS streams)
{
    streams.lightDirectAmbientOcclusion_id50 = lerp(1.0, streams.matAmbientOcclusion_id57, streams.matAmbientOcclusionDirectLightingFactor_id58);
    streams.matDiffuseVisible_id69 = streams.matDiffuse_id53.rgb * lerp(1.0f, streams.matCavity_id59, streams.matCavityDiffuse_id60) * streams.matDiffuseSpecularAlphaBlend_id65.r * streams.matAlphaBlendColor_id66;
    streams.matSpecularVisible_id71 = streams.matSpecular_id55.rgb * streams.matSpecularIntensity_id56 * lerp(1.0f, streams.matCavity_id59, streams.matCavitySpecular_id61) * streams.matDiffuseSpecularAlphaBlend_id65.g * streams.matAlphaBlendColor_id66;
    streams.NdotV_id72 = max(dot(streams.normalWS_id19, streams.viewWS_id68), 0.0001f);
    float roughness = 1.0f - streams.matGlossiness_id54;
    streams.alphaRoughness_id70 = max(roughness * roughness, 0.001);
}
void ResetLightStream_id171(inout PS_STREAMS streams)
{
    streams.lightPositionWS_id41 = 0;
    streams.lightDirectionWS_id42 = 0;
    streams.lightColor_id43 = 0;
    streams.lightColorNdotL_id44 = 0;
    streams.lightSpecularColorNdotL_id45 = 0;
    streams.lightAttenuation_id46 = 1.0f;
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
    streams.lightDirectAmbientOcclusion_id50 = 1.0f;
    streams.NdotL_id49 = 0;
}
void UpdateNormalFromTangentSpace_id23(float3 normalInTangentSpace)
{
}
float4 Compute_id268(inout PS_STREAMS streams)
{
    float x = Compute_id266(streams);
    return float4(x, x, x, x);
}
float4 Compute_id256(inout PS_STREAMS streams)
{
    float x = Compute_id254(streams);
    return float4(x, x, x, x);
}
float4 Compute_id244(inout PS_STREAMS streams)
{
    return Compute_id242(streams);
}
void ResetStream_id174(inout PS_STREAMS streams)
{
    ResetStream_id173();
    streams.matBlend_id40 = 0.0f;
}
void Compute_id479(inout PS_STREAMS streams)
{
    UpdateNormalFromTangentSpace_id23(streams.matNormal_id51);
    if (!streams.IsFrontFace_id1)
        streams.normalWS_id19 = -streams.normalWS_id19;
    ResetLightStream_id171(streams);
    PrepareMaterialForLightingAndShading_id172(streams);

    {
        PrepareForLightingAndShading_id396();
    }

    {
        PrepareForLightingAndShading_id415();
    }
    float3 directLightingContribution = 0;

    {
        PrepareDirectLights_id181();
        const int maxLightCount = GetMaxLightCount_id186();
        int count = GetLightCount_id185();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id183(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id391(streams);
            }

            {
                directLightingContribution += ComputeDirectLightContribution_id447(streams);
            }
        }
    }

    {
        PrepareDirectLights_id210(streams);
        const int maxLightCount = GetMaxLightCount_id211(streams);
        int count = GetLightCount_id212(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id207(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id391(streams);
            }

            {
                directLightingContribution += ComputeDirectLightContribution_id447(streams);
            }
        }
    }

    {
        PrepareDirectLights_id218();
        const int maxLightCount = GetMaxLightCount_id223(streams);
        int count = GetLightCount_id224(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id220(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id391(streams);
            }

            {
                directLightingContribution += ComputeDirectLightContribution_id447(streams);
            }
        }
    }
    float3 environmentLightingContribution = 0;

    {
        PrepareEnvironmentLight_id229(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id392(streams);
        }

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id448(streams);
        }
    }

    {
        PrepareEnvironmentLight_id232(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id392(streams);
        }

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id448(streams);
        }
    }
    streams.shadingColor_id73 += directLightingContribution * PI_id212 + environmentLightingContribution;
    streams.shadingColorAlpha_id74 = streams.matDiffuse_id53.a;

    {
        AfterLightingAndShading_id399();
    }

    {
        AfterLightingAndShading_id418();
    }
}
void Compute_id463(inout PS_STREAMS streams)
{
    float metalness = Compute_id268(streams).r;
    streams.matSpecular_id55 = lerp(0.02, streams.matDiffuse_id53.rgb, metalness);
    streams.matDiffuse_id53.rgb = lerp(streams.matDiffuse_id53.rgb, 0, metalness);
}
void Compute_id458(inout PS_STREAMS streams)
{
    float glossiness = Compute_id256(streams).r;

    {
        glossiness = 1.0 - glossiness;
    }
    streams.matGlossiness_id54 = glossiness;
}
void Compute_id453(inout PS_STREAMS streams)
{
    float4 colorBase = Compute_id244(streams);
    streams.matDiffuse_id53 = colorBase;
    streams.matColorBase_id52 = colorBase;
}
void ResetStream_id175(inout PS_STREAMS streams)
{
    ResetStream_id174(streams);
    streams.matNormal_id51 = float3(0, 0, 1);
    streams.matColorBase_id52 = 0.0f;
    streams.matDiffuse_id53 = 0.0f;
    streams.matDiffuseVisible_id69 = 0.0f;
    streams.matSpecular_id55 = 0.0f;
    streams.matSpecularVisible_id71 = 0.0f;
    streams.matSpecularIntensity_id56 = 1.0f;
    streams.matGlossiness_id54 = 0.0f;
    streams.alphaRoughness_id70 = 1.0f;
    streams.matAmbientOcclusion_id57 = 1.0f;
    streams.matAmbientOcclusionDirectLightingFactor_id58 = 0.0f;
    streams.matCavity_id59 = 1.0f;
    streams.matCavityDiffuse_id60 = 0.0f;
    streams.matCavitySpecular_id61 = 0.0f;
    streams.matEmissive_id62 = 0.0f;
    streams.matEmissiveIntensity_id63 = 0.0f;
    streams.matScatteringStrength_id64 = 1.0f;
    streams.matDiffuseSpecularAlphaBlend_id65 = 1.0f;
    streams.matAlphaBlendColor_id66 = 1.0f;
    streams.matAlphaDiscard_id67 = 0.1f;
}
float4 ComputeShadingPosition_id11(float4 world)
{
    return mul(world, ViewProjection_id29);
}
void PostTransformPosition_id6()
{
}
void PreTransformPosition_id4()
{
}
void Compute_id48(inout PS_STREAMS streams)
{

    {
        Compute_id453(streams);
    }

    {
        Compute_id458(streams);
    }

    {
        Compute_id463(streams);
    }

    {
        Compute_id479(streams);
    }
}
void ResetStream_id47(inout PS_STREAMS streams)
{
    ResetStream_id175(streams);
    streams.shadingColorAlpha_id74 = 1.0f;
}
void PostTransformPosition_id12(inout VS_STREAMS streams)
{
    PostTransformPosition_id6();
    streams.ShadingPosition_id0 = ComputeShadingPosition_id11(streams.PositionWS_id22);
    streams.PositionH_id24 = streams.ShadingPosition_id0;
    streams.DepthVS_id23 = streams.ShadingPosition_id0.w;
}
void TransformPosition_id5()
{
}
void PreTransformPosition_id10(inout VS_STREAMS streams)
{
    PreTransformPosition_id4();
    streams.PositionWS_id22 = mul(streams.Position_id21, World_id32);
}
float4 Compute_id46()
{
    return MaterialIndex_id83;
}
float4 Shading_id31(inout PS_STREAMS streams)
{
    streams.viewWS_id68 = normalize(Eye_id31.xyz - streams.PositionWS_id22.xyz);
    streams.shadingColor_id73 = 0;
    ResetStream_id47(streams);
    Compute_id48(streams);
    return float4(streams.shadingColor_id73, streams.shadingColorAlpha_id74);
}
void PSMain_id1()
{
}
void BaseTransformVS_id8(inout VS_STREAMS streams)
{
    PreTransformPosition_id10(streams);
    TransformPosition_id5();
    PostTransformPosition_id12(streams);
}
void VSMain_id0()
{
}
void PSMain_id3(inout PS_STREAMS streams)
{
    PSMain_id1();
    streams.ColorTarget_id2 = Shading_id31(streams);
    streams.ColorTarget1_id3 = Compute_id46();
}
void GenerateNormal_PS_id22(inout PS_STREAMS streams)
{
    if (dot(streams.normalWS_id19, streams.normalWS_id19) > 0)
        streams.normalWS_id19 = normalize(streams.normalWS_id19);
    streams.meshNormalWS_id17 = streams.normalWS_id19;
}
void GenerateNormal_VS_id21(inout VS_STREAMS streams)
{
    streams.meshNormalWS_id17 = mul(streams.meshNormal_id16, (float3x3)WorldInverseTranspose_id34);
    streams.normalWS_id19 = streams.meshNormalWS_id17;
}
void VSMain_id9(inout VS_STREAMS streams)
{
    VSMain_id0();
    BaseTransformVS_id8(streams);
}
void PSMain_id20(inout PS_STREAMS streams)
{
    GenerateNormal_PS_id22(streams);
    PSMain_id3(streams);
}
void VSMain_id19(inout VS_STREAMS streams)
{
    VSMain_id9(streams);
    GenerateNormal_VS_id21(streams);
}
PS_OUTPUT PSMain(PS_INPUT __input__)
{
    PS_STREAMS streams = (PS_STREAMS)0;
    streams.PositionWS_id22 = __input__.PositionWS_id22;
    streams.ShadingPosition_id0 = __input__.ShadingPosition_id0;
    streams.DepthVS_id23 = __input__.DepthVS_id23;
    streams.normalWS_id19 = __input__.normalWS_id19;
    streams.ScreenPosition_id167 = __input__.ScreenPosition_id167;
    streams.IsFrontFace_id1 = __input__.IsFrontFace_id1;
    streams.ScreenPosition_id167 /= streams.ScreenPosition_id167.w;
    PSMain_id20(streams);
    PS_OUTPUT __output__ = (PS_OUTPUT)0;
    __output__.ColorTarget_id2 = streams.ColorTarget_id2;
    __output__.ColorTarget1_id3 = streams.ColorTarget1_id3;
    return __output__;
}
VS_OUTPUT VSMain(VS_INPUT __input__)
{
    VS_STREAMS streams = (VS_STREAMS)0;
    streams.Position_id21 = __input__.Position_id21;
    streams.meshNormal_id16 = __input__.meshNormal_id16;
    VSMain_id19(streams);
    streams.ScreenPosition_id167 = streams.ShadingPosition_id0;
    VS_OUTPUT __output__ = (VS_OUTPUT)0;
    __output__.PositionWS_id22 = streams.PositionWS_id22;
    __output__.ShadingPosition_id0 = streams.ShadingPosition_id0;
    __output__.DepthVS_id23 = streams.DepthVS_id23;
    __output__.normalWS_id19 = streams.normalWS_id19;
    __output__.ScreenPosition_id167 = streams.ScreenPosition_id167;
    return __output__;
}
