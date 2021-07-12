/**************************
***** Compiler Parameters *****
***************************
@P EffectName: StrideForwardShadingEffect
@P   - Material.PixelStageSurfaceShaders: mixin MaterialSurfaceArray [{layers = [mixin MaterialSurfaceDiffuse [{diffuseMap = mixin Float4ToColor [{Value = mixin DoFloat4 [{Before = mixin ComputeOrder [{Computes = [mixin AssignVarFloat4<Input_0> [{Value = InputFloat4<ShaderFX.InputValueFloat4,PerMaterial>}]]}]}, {Value = GetVarFloat4<Input_0>}]}]}], mixin MaterialSurfaceGlossinessMap<true> [{glossinessMap = mixin FloatToScalar [{Value = mixin DoFloat [{Before = mixin ComputeOrder [{Computes = [mixin AssignVarFloat<Input_1> [{Value = InputFloat<ShaderFX.InputValueFloat,PerMaterial>}]]}]}, {Value = GetVarFloat<Input_1>}]}]}], mixin MaterialSurfaceMetalness [{metalnessMap = mixin FloatToScalar [{Value = mixin DoFloat [{Before = mixin ComputeOrder [{Computes = [mixin AssignVarFloat<Input_2> [{Value = InputFloat<ShaderFX.InputValueFloat.i1,PerMaterial>}]]}]}, {Value = GetVarFloat<Input_2>}]}]}], mixin MaterialSurfaceLightingAndShading [{surfaces = [MaterialSurfaceShadingDiffuseLambert<false>, mixin MaterialSurfaceShadingSpecularMicrofacet [{environmentFunction = MaterialSpecularMicrofacetEnvironmentGGXLUT}, {fresnelFunction = MaterialSpecularMicrofacetFresnelSchlick}, {geometricShadowingFunction = MaterialSpecularMicrofacetVisibilitySmithSchlickGGX}, {normalDistributionFunction = MaterialSpecularMicrofacetNormalDistributionGGX}]]}]]}]
@P Material.PixelStageStreamInitializer: mixin MaterialStream, MaterialPixelShadingStream
@P Lighting.DirectLightGroups: mixin LightDirectionalGroup<8>, mixin LightDirectionalGroup<1>, ShadowMapReceiverDirectional<4,1,true,true,false,false>, ShadowMapFilterDefault<PerView.Lighting>, LightClusteredPointGroup, LightClusteredSpotGroup
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
@C    InputValue_id186 => ShaderFX.InputValueFloat4
@C    InputValue_id194 => ShaderFX.InputValueFloat
@C    InputValue_id203 => ShaderFX.InputValueFloat.i1
cbuffer PerView [Size: 1696]
@C    View_id25 => Transformation.View
@C    ViewInverse_id26 => Transformation.ViewInverse
@C    Projection_id27 => Transformation.Projection
@C    ProjectionInverse_id28 => Transformation.ProjectionInverse
@C    ViewProjection_id29 => Transformation.ViewProjection
@C    ProjScreenRay_id30 => Transformation.ProjScreenRay
@C    Eye_id31 => Transformation.Eye
@C    NearClipPlane_id170 => Camera.NearClipPlane
@C    FarClipPlane_id171 => Camera.FarClipPlane
@C    ZProjection_id172 => Camera.ZProjection
@C    ViewSize_id173 => Camera.ViewSize
@C    AspectRatio_id174 => Camera.AspectRatio
@C    _padding_PerView_Default => _padding_PerView_Default
@C    LightCount_id86 => DirectLightGroupPerView.LightCount.directLightGroups[0]
@C    Lights_id88 => LightDirectionalGroup.Lights.directLightGroups[0]
@C    LightCount_id89 => DirectLightGroupPerView.LightCount.directLightGroups[1]
@C    Lights_id91 => LightDirectionalGroup.Lights.directLightGroups[1]
@C    ShadowMapTextureSize_id93 => ShadowMap.TextureSize.directLightGroups[1]
@C    ShadowMapTextureTexelSize_id94 => ShadowMap.TextureTexelSize.directLightGroups[1]
@C    WorldToShadowCascadeUV_id156 => ShadowMapReceiverBase.WorldToShadowCascadeUV.directLightGroups[1]
@C    InverseWorldToShadowCascadeUV_id157 => ShadowMapReceiverBase.InverseWorldToShadowCascadeUV.directLightGroups[1]
@C    ViewMatrices_id158 => ShadowMapReceiverBase.ViewMatrices.directLightGroups[1]
@C    DepthRanges_id159 => ShadowMapReceiverBase.DepthRanges.directLightGroups[1]
@C    DepthBiases_id160 => ShadowMapReceiverBase.DepthBiases.directLightGroups[1]
@C    OffsetScales_id161 => ShadowMapReceiverBase.OffsetScales.directLightGroups[1]
@C    CascadeDepthSplits_id168 => ShadowMapReceiverDirectional.CascadeDepthSplits.directLightGroups[1]
@C    ClusterDepthScale_id179 => LightClustered.ClusterDepthScale
@C    ClusterDepthBias_id180 => LightClustered.ClusterDepthBias
@C    ClusterStride_id181 => LightClustered.ClusterStride
@C    AmbientLight_id184 => LightSimpleAmbient.AmbientLight.environmentLights[0]
@C    _padding_PerView_Lighting => _padding_PerView_Lighting
***************************
******  Resources    ******
***************************
@R    PerMaterial => PerMaterial [Stage: None, Slot: (-1--1)]
@R    EnvironmentLightingDFG_LUT_id215 => MaterialSpecularMicrofacetEnvironmentGGXLUT.EnvironmentLightingDFG_LUT [Stage: None, Slot: (-1--1)]
@R    EnvironmentLightingDFG_LUT_id215 => MaterialSpecularMicrofacetEnvironmentGGXLUT.EnvironmentLightingDFG_LUT [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id92 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id92 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    LightClusters_id177 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightClusters_id177 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightIndices_id178 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    LightIndices_id178 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    PointLights_id182 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    PointLights_id182 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id183 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id183 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    PerDraw => PerDraw [Stage: Vertex, Slot: (0-0)]
@R    PerView => PerView [Stage: Vertex, Slot: (1-1)]
@R    LinearSampler_id125 => Texturing.LinearSampler [Stage: Pixel, Slot: (0-0)]
@R    LinearClampCompareLessEqualSampler_id127 => Texturing.LinearClampCompareLessEqualSampler [Stage: Pixel, Slot: (1-1)]
@R    EnvironmentLightingDFG_LUT_id215 => MaterialSpecularMicrofacetEnvironmentGGXLUT.EnvironmentLightingDFG_LUT [Stage: Pixel, Slot: (0-0)]
@R    ShadowMapTexture_id92 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: Pixel, Slot: (1-1)]
@R    LightClusters_id177 => LightClustered.LightClusters [Stage: Pixel, Slot: (2-2)]
@R    LightIndices_id178 => LightClustered.LightIndices [Stage: Pixel, Slot: (3-3)]
@R    PointLights_id182 => LightClusteredPointGroup.PointLights [Stage: Pixel, Slot: (4-4)]
@R    SpotLights_id183 => LightClusteredSpotGroup.SpotLights [Stage: Pixel, Slot: (5-5)]
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
@S    ShadowMapFilterDefault => 9c45e5253e19bb8099c26ac84bf398f3
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
@G    Vertex => 6294774bf2f0bcadfc589a4b42753b29
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
//   float NearClipPlane_id170;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id171;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id172;          // Offset:  360 Size:     8 [unused]
//   float2 ViewSize_id173;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id174;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[8];                  // Offset:  416 Size:   252 [unused]
//   int LightCount_id89;               // Offset:  668 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  672
//       float3 Color;                  // Offset:  688
//
//   } Lights_id91;                     // Offset:  672 Size:    28 [unused]
//   float2 ShadowMapTextureSize_id93;  // Offset:  704 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id94;// Offset:  712 Size:     8 [unused]
//   float4x4 WorldToShadowCascadeUV_id156[4];// Offset:  720 Size:   256 [unused]
//   float4x4 InverseWorldToShadowCascadeUV_id157[4];// Offset:  976 Size:   256 [unused]
//   float4x4 ViewMatrices_id158[4];    // Offset: 1232 Size:   256 [unused]
//   float2 DepthRanges_id159[4];       // Offset: 1488 Size:    56 [unused]
//   float DepthBiases_id160;           // Offset: 1552 Size:     4 [unused]
//   float OffsetScales_id161;          // Offset: 1568 Size:     4 [unused]
//   float CascadeDepthSplits_id168[4]; // Offset: 1584 Size:    52 [unused]
//   float ClusterDepthScale_id179;     // Offset: 1636 Size:     4 [unused]
//   float ClusterDepthBias_id180;      // Offset: 1640 Size:     4 [unused]
//   float2 ClusterStride_id181;        // Offset: 1648 Size:     8 [unused]
//   float3 AmbientLight_id184;         // Offset: 1664 Size:    12 [unused]
//   float4 _padding_PerView_Lighting;  // Offset: 1680 Size:    16 [unused]
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
// SCREENPOSITION_ID169_SEM     0   xyzw        3     NONE   float   xyzw
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
//   o3.x <- <VSMain return value>.ScreenPosition_id169.x; o3.y <- <VSMain return value>.ScreenPosition_id169.y; o3.z <- <VSMain return value>.ScreenPosition_id169.z; o3.w <- <VSMain return value>.ScreenPosition_id169.w; 
//   o2.x <- <VSMain return value>.DepthVS_id23; o2.y <- <VSMain return value>.normalWS_id19.x; o2.z <- <VSMain return value>.normalWS_id19.y; o2.w <- <VSMain return value>.normalWS_id19.z; 
//   o1.x <- <VSMain return value>.ShadingPosition_id0.x; o1.y <- <VSMain return value>.ShadingPosition_id0.y; o1.z <- <VSMain return value>.ShadingPosition_id0.z; o1.w <- <VSMain return value>.ShadingPosition_id0.w; 
//   o0.x <- <VSMain return value>.PositionWS_id22.x; o0.y <- <VSMain return value>.PositionWS_id22.y; o0.z <- <VSMain return value>.PositionWS_id22.z; o0.w <- <VSMain return value>.PositionWS_id22.w
//
#line 1125 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_95a7f2475d80733e8965554b10d91f46.hlsl"
dp4 r0.x, v0.xyzw, cb0[0].xyzw  // r0.x <- streams.PositionWS_id22.x
dp4 r0.y, v0.xyzw, cb0[1].xyzw  // r0.y <- streams.PositionWS_id22.y
dp4 r0.z, v0.xyzw, cb0[2].xyzw  // r0.z <- streams.PositionWS_id22.z
dp4 r0.w, v0.xyzw, cb0[3].xyzw  // r0.w <- streams.PositionWS_id22.w

#line 1212
mov o0.xyzw, r0.xyzw

#line 1080
dp4 r1.x, r0.xyzw, cb1[16].xyzw  // r1.x <- <ComputeShadingPosition_id11 return value>.x
dp4 r1.y, r0.xyzw, cb1[17].xyzw  // r1.y <- <ComputeShadingPosition_id11 return value>.y
dp4 r1.z, r0.xyzw, cb1[18].xyzw  // r1.z <- <ComputeShadingPosition_id11 return value>.z
dp4 r1.w, r0.xyzw, cb1[19].xyzw  // r1.w <- <ComputeShadingPosition_id11 return value>.w

#line 1212
mov o1.xyzw, r1.xyzw
mov o3.xyzw, r1.xyzw
mov o2.x, r1.w

#line 1165
dp3 o2.y, v1.xyzx, cb0[8].xyzx
dp3 o2.z, v1.xyzx, cb0[9].xyzx
dp3 o2.w, v1.xyzx, cb0[10].xyzx

#line 1212
ret 
// Approximately 16 instruction slots used
@G    Pixel => 5dab2a7917c9b0b5db0262bf35a19214
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
//   float4 InputValue_id186;           // Offset:    0 Size:    16
//   float InputValue_id194;            // Offset:   16 Size:     4
//   float InputValue_id203;            // Offset:   20 Size:     4
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
//   float NearClipPlane_id170;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id171;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id172;          // Offset:  360 Size:     8
//   float2 ViewSize_id173;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id174;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[8];                  // Offset:  416 Size:   252
//   int LightCount_id89;               // Offset:  668 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  672
//       float3 Color;                  // Offset:  688
//
//   } Lights_id91;                     // Offset:  672 Size:    28
//   float2 ShadowMapTextureSize_id93;  // Offset:  704 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id94;// Offset:  712 Size:     8
//   float4x4 WorldToShadowCascadeUV_id156[4];// Offset:  720 Size:   256
//   float4x4 InverseWorldToShadowCascadeUV_id157[4];// Offset:  976 Size:   256 [unused]
//   float4x4 ViewMatrices_id158[4];    // Offset: 1232 Size:   256 [unused]
//   float2 DepthRanges_id159[4];       // Offset: 1488 Size:    56 [unused]
//   float DepthBiases_id160;           // Offset: 1552 Size:     4
//   float OffsetScales_id161;          // Offset: 1568 Size:     4
//   float CascadeDepthSplits_id168[4]; // Offset: 1584 Size:    52
//   float ClusterDepthScale_id179;     // Offset: 1636 Size:     4
//   float ClusterDepthBias_id180;      // Offset: 1640 Size:     4
//   float2 ClusterStride_id181;        // Offset: 1648 Size:     8
//   float3 AmbientLight_id184;         // Offset: 1664 Size:    12
//   float4 _padding_PerView_Lighting;  // Offset: 1680 Size:    16 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// LinearSampler_id125               sampler      NA          NA             s0      1 
// LinearClampCompareLessEqualSampler_id127  sampler_c      NA          NA             s1      1 
// EnvironmentLightingDFG_LUT_id215    texture  float4          2d             t0      1 
// ShadowMapTexture_id92             texture  float4          2d             t1      1 
// LightClusters_id177               texture   uint2          3d             t2      1 
// LightIndices_id178                texture    uint         buf             t3      1 
// PointLights_id182                 texture  float4         buf             t4      1 
// SpotLights_id183                  texture  float4         buf             t5      1 
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
// SCREENPOSITION_ID169_SEM     0   xyzw        3     NONE   float   xy w
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
dcl_constantbuffer CB2[105], dynamicIndexed
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
dcl_temps 19
//
// Initial variable locations:
//   v0.x <- __input__.PositionWS_id22.x; v0.y <- __input__.PositionWS_id22.y; v0.z <- __input__.PositionWS_id22.z; v0.w <- __input__.PositionWS_id22.w; 
//   v1.x <- __input__.ShadingPosition_id0.x; v1.y <- __input__.ShadingPosition_id0.y; v1.z <- __input__.ShadingPosition_id0.z; v1.w <- __input__.ShadingPosition_id0.w; 
//   v2.x <- __input__.DepthVS_id23; v2.y <- __input__.normalWS_id19.x; v2.z <- __input__.normalWS_id19.y; v2.w <- __input__.normalWS_id19.z; 
//   v3.x <- __input__.ScreenPosition_id169.x; v3.y <- __input__.ScreenPosition_id169.y; v3.z <- __input__.ScreenPosition_id169.z; v3.w <- __input__.ScreenPosition_id169.w; 
//   v4.x <- __input__.IsFrontFace_id1; 
//   o1.x <- <PSMain return value>.ColorTarget1_id3.x; o1.y <- <PSMain return value>.ColorTarget1_id3.y; o1.z <- <PSMain return value>.ColorTarget1_id3.z; o1.w <- <PSMain return value>.ColorTarget1_id3.w; 
//   o0.x <- <PSMain return value>.ColorTarget_id2.x; o0.y <- <PSMain return value>.ColorTarget_id2.y; o0.z <- <PSMain return value>.ColorTarget_id2.z; o0.w <- <PSMain return value>.ColorTarget_id2.w
//
#line 1192 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_95a7f2475d80733e8965554b10d91f46.hlsl"
div r0.xy, v3.xyxx, v3.wwww  // r0.x <- streams.ScreenPosition_id169.x; r0.y <- streams.ScreenPosition_id169.y

#line 1159
dp3 r0.z, v2.yzwy, v2.yzwy
lt r0.w, l(0.000000), r0.z

#line 1160
rsq r0.z, r0.z
mul r1.xyz, r0.zzzz, v2.yzwy  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z
movc r1.xyz, r0.wwww, r1.xyzx, v2.yzwy

#line 1133
add r2.xyz, -v0.xyzx, cb2[21].xyzx
dp3 r0.z, r2.xyzx, r2.xyzx
rsq r0.z, r0.z
mul r3.xyz, r0.zzzz, r2.xyzx  // r3.x <- streams.viewWS_id68.x; r3.y <- streams.viewWS_id68.y; r3.z <- streams.viewWS_id68.z

#line 1044
add r0.w, -cb1[1].x, l(1.000000)  // r0.w <- glossiness

#line 1036
add r4.xyz, cb1[0].xyzx, l(-0.020000, -0.020000, -0.020000, 0.000000)
mad r4.xyz, cb1[1].yyyy, r4.xyzx, l(0.020000, 0.020000, 0.020000, 0.000000)  // r4.x <- streams.matSpecular_id55.x; r4.y <- streams.matSpecular_id55.y; r4.z <- streams.matSpecular_id55.z

#line 1037
mad r5.xyz, cb1[1].yyyy, -cb1[0].xyzx, cb1[0].xyzx  // r5.x <- streams.matDiffuse_id53.x; r5.y <- streams.matDiffuse_id53.y; r5.z <- streams.matDiffuse_id53.z

#line 889
movc r1.xyz, v4.xxxx, r1.xyzx, -r1.xyzx  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z

#line 846
dp3 r1.w, r1.xyzx, r3.xyzx
max r6.y, r1.w, l(0.000100)  // r6.y <- streams.NdotV_id72

#line 847
add r0.w, -r0.w, l(1.000000)  // r0.w <- roughness

#line 848
mul r0.w, r0.w, r0.w
max r0.w, r0.w, l(0.001000)  // r0.w <- streams.alphaRoughness_id70

#line 907
mov r7.xyz, r1.xyzx  // r7.x <- streams.normalWS_id19.x; r7.y <- streams.normalWS_id19.y; r7.z <- streams.normalWS_id19.z
mov r8.xyz, r5.xyzx  // r8.x <- streams.matDiffuseVisible_id69.x; r8.y <- streams.matDiffuseVisible_id69.y; r8.z <- streams.matDiffuseVisible_id69.z
mov r9.xyz, r4.xyzx  // r9.x <- streams.matSpecularVisible_id71.x; r9.y <- streams.matSpecularVisible_id71.y; r9.z <- streams.matSpecularVisible_id71.z
mov r10.xyz, l(0,0,0,0)  // r10.x <- directLightingContribution.x; r10.y <- directLightingContribution.y; r10.z <- directLightingContribution.z
mov r11.xyz, r3.xyzx  // r11.x <- streams.viewWS_id68.x; r11.y <- streams.viewWS_id68.y; r11.z <- streams.viewWS_id68.z
mov r1.w, r0.w  // r1.w <- streams.alphaRoughness_id70
mov r2.w, r6.y  // r2.w <- streams.NdotV_id72
mov r3.w, l(0)  // r3.w <- i
loop 
  ige r4.w, r3.w, l(8)
  breakc_nz r4.w

#line 909
  ige r4.w, r3.w, cb2[25].x
  if_nz r4.w

#line 911
    break 

#line 912
  endif 

#line 676
  ishl r4.w, r3.w, l(1)

#line 816
  dp3 r5.w, r7.xyzx, -cb2[r4.w + 26].xyzx
  max r5.w, r5.w, l(0.000100)  // r5.w <- streams.NdotL_id49

#line 818
  mul r12.xyz, r5.wwww, cb2[r4.w + 27].xyzx  // r12.x <- streams.lightColorNdotL_id44.x; r12.y <- streams.lightColorNdotL_id44.y; r12.z <- streams.lightColorNdotL_id44.z

#line 808
  add r13.xyz, r11.xyzx, -cb2[r4.w + 26].xyzx
  dp3 r6.z, r13.xyzx, r13.xyzx
  rsq r6.z, r6.z
  mul r13.xyz, r6.zzzz, r13.xyzx  // r13.x <- streams.H_id75.x; r13.y <- streams.H_id75.y; r13.z <- streams.H_id75.z

#line 809
  dp3_sat r6.z, r7.xyzx, r13.xyzx  // r6.z <- streams.NdotH_id76

#line 810
  dp3_sat r4.w, -cb2[r4.w + 26].xyzx, r13.xyzx  // r4.w <- streams.LdotH_id77

#line 804
  mul r13.xyz, r8.xyzx, r12.xyzx

#line 917
  mad r13.xyz, r13.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r10.xyzx  // r13.x <- directLightingContribution.x; r13.y <- directLightingContribution.y; r13.z <- directLightingContribution.z

#line 424
  add r14.xyz, -r9.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r4.w, -r4.w, l(1.000000)
  mul r6.w, r4.w, r4.w
  mul r6.w, r6.w, r6.w
  mul r4.w, r4.w, r6.w
  mad r14.xyz, r14.xyzx, r4.wwww, r9.xyzx  // r14.x <- <FresnelSchlick_id139 return value>.x; r14.y <- <FresnelSchlick_id139 return value>.y; r14.z <- <FresnelSchlick_id139 return value>.z

#line 419
  mul r4.w, r1.w, l(0.500000)  // r4.w <- k

#line 420
  mad r6.w, -r1.w, l(0.500000), l(1.000000)
  mad r7.w, r5.w, r6.w, r4.w
  div r7.w, r5.w, r7.w  // r7.w <- <VisibilityhSchlickGGX_id155 return value>
  mad r4.w, r2.w, r6.w, r4.w
  div r4.w, r2.w, r4.w  // r4.w <- <VisibilityhSchlickGGX_id155 return value>

#line 480
  mul r4.w, r4.w, r7.w
  mul r5.w, r2.w, r5.w
  div r4.w, r4.w, r5.w  // r4.w <- <VisibilitySmithSchlickGGX_id157 return value>

#line 474
  mul r5.w, r1.w, r1.w  // r5.w <- alphaR2

#line 475
  mul r6.z, r6.z, r6.z
  mad r6.w, r1.w, r1.w, l(-1.000000)
  mad r6.z, r6.z, r6.w, l(1.000000)
  max r6.z, r6.z, l(0.000100)  // r6.z <- d

#line 476
  mul r6.z, r6.z, r6.z
  mul r6.z, r6.z, l(3.141593)
  div r5.w, r5.w, r6.z  // r5.w <- <NormalDistributionGGX_id169 return value>

#line 798
  mul r14.xyz, r4.wwww, r14.xyzx
  mul r14.xyz, r5.wwww, r14.xyzx
  mul r12.xyz, r12.xyzx, r14.xyzx

#line 921
  mad r10.xyz, r12.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r13.xyzx  // r10.x <- directLightingContribution.x; r10.y <- directLightingContribution.y; r10.z <- directLightingContribution.z

#line 907
  iadd r3.w, r3.w, l(1)

#line 923
endloop 

#line 937
ilt r1.w, l(0), cb2[41].w
if_nz r1.w

#line 773
  dp3 r1.w, r1.xyzx, -cb2[42].xyzx
  max r1.w, r1.w, l(0.000100)  // r1.w <- streams.NdotL_id49

#line 609
  lt r2.w, cb2[99].x, v2.x

#line 612
  and r2.w, r2.w, l(1)  // r2.w <- cascadeIndex

#line 609
  lt r3.w, cb2[100].x, v2.x

#line 612
  movc r2.w, r3.w, l(2), r2.w

#line 609
  lt r3.w, cb2[101].x, v2.x

#line 612
  movc r2.w, r3.w, l(3), r2.w

#line 469
  add r4.w, -r1.w, l(1.000000)
  max r4.w, r4.w, l(0.000000)  // r4.w <- normalOffsetScale

#line 470
  mul r5.w, cb2[44].z, cb2[98].x
  dp2 r4.w, r5.wwww, r4.wwww

#line 617
  mad r7.xyz, r4.wwww, r1.xyzx, v0.xyzx  // r7.x <- shadowPosition.x; r7.y <- shadowPosition.y; r7.z <- shadowPosition.z

#line 462
  ishl r4.w, r2.w, l(2)
  mov r7.w, l(1.000000)
  dp4 r8.x, r7.xyzw, cb2[r4.w + 45].xyzw  // r8.x <- shadowPosition.x
  dp4 r8.y, r7.xyzw, cb2[r4.w + 46].xyzw  // r8.y <- shadowPosition.y
  dp4 r5.w, r7.xyzw, cb2[r4.w + 47].xyzw  // r5.w <- shadowPosition.z
  dp4 r6.z, r7.xyzw, cb2[r4.w + 48].xyzw  // r6.z <- shadowPosition.w

#line 463
  add r8.z, r5.w, -cb2[97].x  // r8.z <- shadowPosition.z

#line 464
  div r8.xyz, r8.xyzx, r6.zzzz

#line 415
  sample_c_lz_indexable(texture2d)(float,float,float,float) r5.w, r8.xyxx, t1.xxxx, s1, r8.z  // r5.w <- <FilterShadow_id64 return value>

#line 623
  ilt r6.z, l(0), r2.w
  if_nz r6.z

#line 625
    iadd r6.z, r2.w, l(-1)
    add r6.z, -cb2[r6.z + 99].x, cb2[r2.w + 99].x  // r6.z <- splitSize

#line 626
  else 
    mov r6.z, cb2[r2.w + 99].x  // r6.z <- splitSize
  endif 

#line 627
  add r2.w, -v2.x, cb2[r2.w + 99].x
  div r2.w, r2.w, r6.z  // r2.w <- splitDist

#line 628
  lt r6.z, r2.w, l(0.200000)
  if_nz r6.z

#line 631
    if_nz r3.w

#line 633
      mov r8.xyz, r5.wwww  // r8.x <- shadow.x; r8.y <- shadow.y; r8.z <- shadow.z
    else 

#line 630
      mul_sat r2.w, r2.w, l(5.000000)
      mad r3.w, r2.w, l(-2.000000), l(3.000000)
      mul r2.w, r2.w, r2.w
      mul r2.w, r2.w, r3.w  // r2.w <- lerpAmt

#line 462
      dp4 r9.x, r7.xyzw, cb2[r4.w + 49].xyzw  // r9.x <- shadowPosition.x
      dp4 r9.y, r7.xyzw, cb2[r4.w + 50].xyzw  // r9.y <- shadowPosition.y
      dp4 r3.w, r7.xyzw, cb2[r4.w + 51].xyzw  // r3.w <- shadowPosition.z
      dp4 r4.w, r7.xyzw, cb2[r4.w + 52].xyzw  // r4.w <- shadowPosition.w

#line 463
      add r9.z, r3.w, -cb2[97].x  // r9.z <- shadowPosition.z

#line 464
      div r7.xyz, r9.xyzx, r4.wwww  // r7.x <- shadowPosition.x; r7.y <- shadowPosition.y; r7.z <- shadowPosition.z

#line 415
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.w, r7.xyxx, t1.xxxx, s1, r7.z  // r3.w <- <FilterShadow_id64 return value>

#line 637
      add r4.w, -r3.w, r5.w
      mad r8.xyz, r2.wwww, r4.wwww, r3.wwww  // r8.x <- shadow.x; r8.y <- shadow.y; r8.z <- shadow.z

#line 638
    endif 

#line 639
  else   // Prior locations: r9.x <- streams.matSpecularVisible_id71.x; r9.y <- streams.matSpecularVisible_id71.y; r9.z <- streams.matSpecularVisible_id71.z; r7.x <- shadowPosition.x; r7.y <- shadowPosition.y; r7.z <- shadowPosition.z; r2.w <- splitDist
    mov r8.xyz, r5.wwww  // r8.x <- shadow.x; r8.y <- shadow.y; r8.z <- shadow.z
  endif 

#line 775
  mul r7.xyz, r8.xyzx, cb2[43].xyzx
  mul r7.xyz, r1.wwww, r7.xyzx  // r7.x <- streams.lightColorNdotL_id44.x; r7.y <- streams.lightColorNdotL_id44.y; r7.z <- streams.lightColorNdotL_id44.z

#line 808
  mad r2.xyz, r2.xyzx, r0.zzzz, -cb2[42].xyzx
  dp3 r0.z, r2.xyzx, r2.xyzx
  rsq r0.z, r0.z
  mul r2.xyz, r0.zzzz, r2.xyzx  // r2.x <- streams.H_id75.x; r2.y <- streams.H_id75.y; r2.z <- streams.H_id75.z

#line 809
  dp3_sat r0.z, r1.xyzx, r2.xyzx  // r0.z <- streams.NdotH_id76

#line 810
  dp3_sat r2.x, -cb2[42].xyzx, r2.xyzx  // r2.x <- streams.LdotH_id77

#line 804
  mul r2.yzw, r5.xxyz, r7.xxyz

#line 941
  mad r2.yzw, r2.yyzw, l(0.000000, 0.318310, 0.318310, 0.318310), r10.xxyz  // r2.y <- directLightingContribution.x; r2.z <- directLightingContribution.y; r2.w <- directLightingContribution.z

#line 424
  add r8.xyz, -r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r2.x, -r2.x, l(1.000000)
  mul r3.w, r2.x, r2.x
  mul r3.w, r3.w, r3.w
  mul r2.x, r2.x, r3.w
  mad r8.xyz, r8.xyzx, r2.xxxx, r4.xyzx  // r8.x <- <FresnelSchlick_id139 return value>.x; r8.y <- <FresnelSchlick_id139 return value>.y; r8.z <- <FresnelSchlick_id139 return value>.z

#line 419
  mul r2.x, r0.w, l(0.500000)  // r2.x <- k

#line 420
  mad r3.w, -r0.w, l(0.500000), l(1.000000)
  mad r4.w, r1.w, r3.w, r2.x
  div r4.w, r1.w, r4.w  // r4.w <- <VisibilityhSchlickGGX_id155 return value>
  mad r2.x, r6.y, r3.w, r2.x
  div r2.x, r6.y, r2.x  // r2.x <- <VisibilityhSchlickGGX_id155 return value>

#line 480
  mul r2.x, r2.x, r4.w
  mul r1.w, r6.y, r1.w
  div r1.w, r2.x, r1.w  // r1.w <- <VisibilitySmithSchlickGGX_id157 return value>

#line 474
  mul r2.x, r0.w, r0.w  // r2.x <- alphaR2

#line 475
  mul r0.z, r0.z, r0.z
  mad r3.w, r0.w, r0.w, l(-1.000000)
  mad r0.z, r0.z, r3.w, l(1.000000)
  max r0.z, r0.z, l(0.000100)  // r0.z <- d

#line 476
  mul r0.z, r0.z, r0.z
  mul r0.z, r0.z, l(3.141593)
  div r0.z, r2.x, r0.z  // r0.z <- <NormalDistributionGGX_id169 return value>

#line 798
  mul r8.xyz, r1.wwww, r8.xyzx
  mul r8.xyz, r0.zzzz, r8.xyzx
  mul r7.xyz, r7.xyzx, r8.xyzx

#line 945
  mad r10.xyz, r7.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r2.yzwy  // r10.x <- directLightingContribution.x; r10.y <- directLightingContribution.y; r10.z <- directLightingContribution.z

#line 946
endif 

#line 586
add r0.z, v1.z, -cb2[22].z
div r0.z, cb2[22].w, r0.z  // r0.z <- depth

#line 587
mad r0.xy, r0.xyxx, l(1.000000, -1.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
mul r0.xy, r0.xyxx, cb2[103].xyxx

#line 588
mad r0.z, r0.z, cb2[102].y, cb2[102].z
log r0.z, r0.z
max r0.z, r0.z, l(0.000000)

#line 589
mul r0.xy, r0.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)

#line 588
ftoi r2.xyz, r0.xyzx  // r2.z <- slice

#line 589
mov r2.w, l(0)
ld_indexable(texture3d)(uint,uint,uint,uint) r0.xy, r2.xyzw, t2.xyzw  // r0.x <- streams.lightData_id175.x; r0.y <- streams.lightData_id175.y

#line 764
and r0.z, r0.y, l(0x0000ffff)  // r0.z <- <GetMaxLightCount_id221 return value>

#line 955
mov r2.xyz, r1.xyzx  // r2.x <- streams.normalWS_id19.x; r2.y <- streams.normalWS_id19.y; r2.z <- streams.normalWS_id19.z
mov r2.w, v0.x  // r2.w <- streams.PositionWS_id22.x
mov r7.xy, v0.yzyy  // r7.x <- streams.PositionWS_id22.y; r7.y <- streams.PositionWS_id22.z
mov r7.zw, r3.xxxy  // r7.z <- streams.viewWS_id68.x; r7.w <- streams.viewWS_id68.y
mov r8.z, r3.z  // r8.z <- streams.viewWS_id68.z
mov r9.xyz, r5.xyzx  // r9.x <- streams.matDiffuseVisible_id69.x; r9.y <- streams.matDiffuseVisible_id69.y; r9.z <- streams.matDiffuseVisible_id69.z
mov r11.xyz, r4.xyzx  // r11.x <- streams.matSpecularVisible_id71.x; r11.y <- streams.matSpecularVisible_id71.y; r11.z <- streams.matSpecularVisible_id71.z
mov r11.w, r0.w  // r11.w <- streams.alphaRoughness_id70
mov r6.w, r6.y  // r6.w <- streams.NdotV_id72
mov r6.z, r0.x  // r6.z <- streams.lightIndex_id176
mov r12.xyz, r10.xyzx  // r12.x <- directLightingContribution.x; r12.y <- directLightingContribution.y; r12.z <- directLightingContribution.z
mov r1.w, l(0)  // r1.w <- i
loop 
  ige r3.w, r1.w, r0.z
  breakc_nz r3.w

#line 957
  if_nz r3.w

#line 959
    break 

#line 960
  endif 

#line 573
  ld_indexable(buffer)(uint,uint,uint,uint) r3.w, r6.zzzz, t3.yzwx  // r3.w <- realLightIndex

#line 574
  iadd r6.z, r6.z, l(1)  // r6.z <- streams.lightIndex_id176

#line 576
  ishl r4.w, r3.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r13.xyzw, r4.wwww, t4.xyzw  // r13.x <- pointLight1.x; r13.y <- pointLight1.y; r13.z <- pointLight1.z; r13.w <- pointLight1.w

#line 577
  bfi r3.w, l(31), l(1), r3.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r14.xyz, r3.wwww, t4.xyzw  // r14.x <- pointLight2.x; r14.y <- pointLight2.y; r14.z <- pointLight2.z

#line 392
  mov r15.x, r2.w
  mov r15.yz, r7.xxyx
  add r13.xyz, r13.xyzx, -r15.xyzx  // r13.x <- lightVector.x; r13.y <- lightVector.y; r13.z <- lightVector.z

#line 393
  dp3 r3.w, r13.xyzx, r13.xyzx
  sqrt r4.w, r3.w  // r4.w <- lightVectorLength

#line 394
  div r13.xyz, r13.xyzx, r4.wwww  // r13.x <- lightVectorNorm.x; r13.y <- lightVectorNorm.y; r13.z <- lightVectorNorm.z

#line 326
  max r4.w, r3.w, l(0.000100)
  div r4.w, l(1.000000, 1.000000, 1.000000, 1.000000), r4.w  // r4.w <- attenuation

#line 299
  mul r3.w, r13.w, r3.w  // r3.w <- factor

#line 300
  mad r3.w, -r3.w, r3.w, l(1.000000)
  max r3.w, r3.w, l(0.000000)  // r3.w <- smoothFactor

#line 301
  mul r3.w, r3.w, r3.w  // r3.w <- <SmoothDistanceAttenuation_id78 return value>

#line 327
  mul r3.w, r3.w, r4.w  // r3.w <- attenuation

#line 750
  dp3 r4.w, r2.xyzx, r13.xyzx
  max r4.w, r4.w, l(0.000100)  // r4.w <- streams.NdotL_id49

#line 752
  mul r14.xyz, r3.wwww, r14.xyzx
  mul r14.xyz, r4.wwww, r14.xyzx  // r14.x <- streams.lightColorNdotL_id44.x; r14.y <- streams.lightColorNdotL_id44.y; r14.z <- streams.lightColorNdotL_id44.z

#line 808
  mov r8.xy, r7.zwzz
  add r8.xyw, r13.xyxz, r8.xyxz
  dp3 r3.w, r8.xywx, r8.xywx
  rsq r3.w, r3.w
  mul r8.xyw, r3.wwww, r8.xyxw  // r8.x <- streams.H_id75.x; r8.y <- streams.H_id75.y; r8.w <- streams.H_id75.z

#line 809
  dp3_sat r3.w, r2.xyzx, r8.xywx  // r3.w <- streams.NdotH_id76

#line 810
  dp3_sat r5.w, r13.xyzx, r8.xywx  // r5.w <- streams.LdotH_id77

#line 804
  mul r8.xyw, r9.xyxz, r14.xyxz

#line 965
  mad r8.xyw, r8.xyxw, l(0.318310, 0.318310, 0.000000, 0.318310), r12.xyxz  // r8.x <- directLightingContribution.x; r8.y <- directLightingContribution.y; r8.w <- directLightingContribution.z

#line 424
  add r13.xyz, -r11.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r5.w, -r5.w, l(1.000000)
  mul r9.w, r5.w, r5.w
  mul r9.w, r9.w, r9.w
  mul r5.w, r5.w, r9.w
  mad r13.xyz, r13.xyzx, r5.wwww, r11.xyzx  // r13.x <- <FresnelSchlick_id139 return value>.x; r13.y <- <FresnelSchlick_id139 return value>.y; r13.z <- <FresnelSchlick_id139 return value>.z

#line 419
  mul r5.w, r11.w, l(0.500000)  // r5.w <- k

#line 420
  mad r9.w, -r11.w, l(0.500000), l(1.000000)
  mad r10.w, r4.w, r9.w, r5.w
  div r10.w, r4.w, r10.w  // r10.w <- <VisibilityhSchlickGGX_id155 return value>
  mad r5.w, r6.w, r9.w, r5.w
  div r5.w, r6.w, r5.w  // r5.w <- <VisibilityhSchlickGGX_id155 return value>

#line 480
  mul r5.w, r5.w, r10.w
  mul r4.w, r6.w, r4.w
  div r4.w, r5.w, r4.w  // r4.w <- <VisibilitySmithSchlickGGX_id157 return value>

#line 474
  mul r5.w, r11.w, r11.w  // r5.w <- alphaR2

#line 475
  mul r3.w, r3.w, r3.w
  mad r9.w, r11.w, r11.w, l(-1.000000)
  mad r3.w, r3.w, r9.w, l(1.000000)
  max r3.w, r3.w, l(0.000100)  // r3.w <- d

#line 476
  mul r3.w, r3.w, r3.w
  mul r3.w, r3.w, l(3.141593)
  div r3.w, r5.w, r3.w  // r3.w <- <NormalDistributionGGX_id169 return value>

#line 798
  mul r13.xyz, r4.wwww, r13.xyzx
  mul r13.xyz, r3.wwww, r13.xyzx
  mul r13.xyz, r14.xyzx, r13.xyzx

#line 969
  mad r12.xyz, r13.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r8.xywx  // r12.x <- directLightingContribution.x; r12.y <- directLightingContribution.y; r12.z <- directLightingContribution.z

#line 955
  iadd r1.w, r1.w, l(1)

#line 971
endloop   // r6.z <- streams.lightIndex_id176

#line 742
ushr r0.x, r0.y, l(16)  // r0.x <- <GetMaxLightCount_id233 return value>

#line 979
mov r2.xyz, r1.xyzx
mov r2.w, v0.x
mov r7.xy, v0.yzyy
mov r7.zw, r3.xxxy
mov r8.z, r3.z
mov r9.xyz, r5.xyzx
mov r10.xyz, r4.xyzx  // r10.x <- streams.matSpecularVisible_id71.x; r10.y <- streams.matSpecularVisible_id71.y; r10.z <- streams.matSpecularVisible_id71.z
mov r11.x, r0.w  // r11.x <- streams.alphaRoughness_id70
mov r11.z, r6.y  // r11.z <- streams.NdotV_id72
mov r13.xyz, r12.xyzx  // r13.x <- directLightingContribution.x; r13.y <- directLightingContribution.y; r13.z <- directLightingContribution.z
mov r0.y, r6.z  // r0.y <- streams.lightIndex_id176
mov r0.z, l(0)  // r0.z <- i
loop 
  ige r1.w, r0.z, r0.x
  breakc_nz r1.w

#line 981
  if_nz r1.w

#line 983
    break 

#line 984
  endif 

#line 545
  ld_indexable(buffer)(uint,uint,uint,uint) r1.w, r0.yyyy, t3.yzwx  // r1.w <- realLightIndex

#line 546
  iadd r0.y, r0.y, l(1)  // r0.y <- streams.lightIndex_id176

#line 548
  ishl r3.w, r1.w, l(2)
  ld_indexable(buffer)(float,float,float,float) r14.xyz, r3.wwww, t5.xyzw  // r14.x <- spotLight1.x; r14.y <- spotLight1.y; r14.z <- spotLight1.z

#line 551
  bfi r15.xyz, l(30, 30, 30, 0), l(2, 2, 2, 0), r1.wwww, l(1, 2, 3, 0)

#line 549
  ld_indexable(buffer)(float,float,float,float) r16.xyz, r15.xxxx, t5.xyzw  // r16.x <- spotLight2.x; r16.y <- spotLight2.y; r16.z <- spotLight2.z

#line 550
  ld_indexable(buffer)(float,float,float,float) r15.xyw, r15.yyyy, t5.xywz  // r15.x <- spotLight3.x; r15.y <- spotLight3.y; r15.w <- spotLight3.z

#line 551
  ld_indexable(buffer)(float,float,float,float) r17.xyz, r15.zzzz, t5.xyzw  // r17.x <- spotLight4.x; r17.y <- spotLight4.y; r17.z <- spotLight4.z

#line 379
  mov r18.x, r2.w
  mov r18.yz, r7.xxyx
  add r14.xyz, r14.xyzx, -r18.xyzx  // r14.x <- lightVector.x; r14.y <- lightVector.y; r14.z <- lightVector.z

#line 380
  dp3 r1.w, r14.xyzx, r14.xyzx
  sqrt r3.w, r1.w  // r3.w <- lightVectorLength

#line 381
  div r14.xyz, r14.xyzx, r3.wwww  // r14.x <- lightVectorNorm.x; r14.y <- lightVectorNorm.y; r14.z <- lightVectorNorm.z

#line 319
  max r3.w, r1.w, l(0.000100)
  div r3.w, l(1.000000, 1.000000, 1.000000, 1.000000), r3.w  // r3.w <- attenuation

#line 293
  mul r1.w, r15.w, r1.w  // r1.w <- factor

#line 294
  mad r1.w, -r1.w, r1.w, l(1.000000)
  max r1.w, r1.w, l(0.000000)  // r1.w <- smoothFactor

#line 295
  mul r1.w, r1.w, r1.w  // r1.w <- <SmoothDistanceAttenuation_id89 return value>

#line 320
  mul r1.w, r1.w, r3.w  // r1.w <- attenuation

#line 311
  dp3 r3.w, -r16.xyzx, r14.xyzx  // r3.w <- cd

#line 312
  mad_sat r3.w, r3.w, r15.x, r15.y  // r3.w <- attenuation

#line 313
  mul r3.w, r3.w, r3.w

#line 387
  mul r1.w, r1.w, r3.w  // r1.w <- attenuation

#line 728
  dp3 r3.w, r2.xyzx, r14.xyzx
  max r3.w, r3.w, l(0.000100)  // r3.w <- streams.NdotL_id49

#line 730
  mul r15.xyz, r1.wwww, r17.xyzx
  mul r15.xyz, r3.wwww, r15.xyzx  // r15.x <- streams.lightColorNdotL_id44.x; r15.y <- streams.lightColorNdotL_id44.y; r15.z <- streams.lightColorNdotL_id44.z

#line 808
  mov r8.xy, r7.zwzz
  add r8.xyw, r14.xyxz, r8.xyxz
  dp3 r1.w, r8.xywx, r8.xywx
  rsq r1.w, r1.w
  mul r8.xyw, r1.wwww, r8.xyxw  // r8.x <- streams.H_id75.x; r8.y <- streams.H_id75.y; r8.w <- streams.H_id75.z

#line 809
  dp3_sat r1.w, r2.xyzx, r8.xywx  // r1.w <- streams.NdotH_id76

#line 810
  dp3_sat r4.w, r14.xyzx, r8.xywx  // r4.w <- streams.LdotH_id77

#line 804
  mul r8.xyw, r9.xyxz, r15.xyxz

#line 989
  mad r8.xyw, r8.xyxw, l(0.318310, 0.318310, 0.000000, 0.318310), r13.xyxz  // r8.x <- directLightingContribution.x; r8.y <- directLightingContribution.y; r8.w <- directLightingContribution.z

#line 424
  add r14.xyz, -r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  add r4.w, -r4.w, l(1.000000)
  mul r5.w, r4.w, r4.w
  mul r5.w, r5.w, r5.w
  mul r4.w, r4.w, r5.w
  mad r14.xyz, r14.xyzx, r4.wwww, r10.xyzx  // r14.x <- <FresnelSchlick_id139 return value>.x; r14.y <- <FresnelSchlick_id139 return value>.y; r14.z <- <FresnelSchlick_id139 return value>.z

#line 419
  mul r4.w, r11.x, l(0.500000)  // r4.w <- k

#line 420
  mad r5.w, -r11.x, l(0.500000), l(1.000000)
  mad r6.w, r3.w, r5.w, r4.w
  div r6.w, r3.w, r6.w  // r6.w <- <VisibilityhSchlickGGX_id155 return value>
  mad r4.w, r11.z, r5.w, r4.w
  div r4.w, r11.z, r4.w  // r4.w <- <VisibilityhSchlickGGX_id155 return value>

#line 480
  mul r4.w, r4.w, r6.w
  mul r3.w, r11.z, r3.w
  div r3.w, r4.w, r3.w  // r3.w <- <VisibilitySmithSchlickGGX_id157 return value>

#line 474
  mul r4.w, r11.x, r11.x  // r4.w <- alphaR2

#line 475
  mul r1.w, r1.w, r1.w
  mad r5.w, r11.x, r11.x, l(-1.000000)
  mad r1.w, r1.w, r5.w, l(1.000000)
  max r1.w, r1.w, l(0.000100)  // r1.w <- d

#line 476
  mul r1.w, r1.w, r1.w
  mul r1.w, r1.w, l(3.141593)
  div r1.w, r4.w, r1.w  // r1.w <- <NormalDistributionGGX_id169 return value>

#line 798
  mul r14.xyz, r3.wwww, r14.xyzx
  mul r14.xyz, r1.wwww, r14.xyzx
  mul r14.xyz, r15.xyzx, r14.xyzx

#line 993
  mad r13.xyz, r14.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r8.xywx  // r13.x <- directLightingContribution.x; r13.y <- directLightingContribution.y; r13.z <- directLightingContribution.z

#line 979
  iadd r0.z, r0.z, l(1)

#line 995
endloop   // r0.y <- streams.lightIndex_id176

#line 521
sqrt r0.x, r0.w
add r6.x, -r0.x, l(1.000000)  // r6.x <- glossiness

#line 522
sample_l_indexable(texture2d)(float,float,float,float) r0.xy, r6.xyxx, t0.xyzw, s0, l(0.000000)  // r0.x <- environmentLightingDFG.x; r0.y <- environmentLightingDFG.y

#line 523
mad r0.xyz, r4.xyzx, r0.xxxx, r0.yyyy  // r0.x <- <Compute_id279 return value>.x; r0.y <- <Compute_id279 return value>.y; r0.z <- <Compute_id279 return value>.z

#line 711
mul r0.xyz, r0.xyzx, cb2[104].xyzx  // r0.x <- <ComputeEnvironmentLightContribution_id458 return value>.x; r0.y <- <ComputeEnvironmentLightContribution_id458 return value>.y; r0.z <- <ComputeEnvironmentLightContribution_id458 return value>.z

#line 1007
mad r0.xyz, r5.xyzx, cb2[104].xyzx, r0.xyzx  // r0.x <- environmentLightingContribution.x; r0.y <- environmentLightingContribution.y; r0.z <- environmentLightingContribution.z

#line 1022
mad o0.xyz, r13.xyzx, l(3.141593, 3.141593, 3.141593, 0.000000), r0.xyzx

#line 1129
utof o1.xyzw, cb0[26].xxxx

#line 1197
mov o0.w, cb1[0].w
ret 
// Approximately 356 instruction slots used
***************************
*************************/
const static int TMaxLightCount_id87 = 8;
const static int TMaxLightCount_id90 = 1;
const static int TCascadeCountBase_id154 = 4;
const static int TLightCountBase_id155 = 1;
const static int TCascadeCount_id162 = 4;
const static int TLightCount_id163 = 1;
const static bool TBlendCascades_id164 = true;
const static bool TDepthRangeAuto_id165 = true;
const static bool TCascadeDebug_id166 = false;
const static bool TComputeTransmittance_id167 = false;
const static bool TInvert_id200 = true;
const static bool TIsEnergyConservative_id212 = false;
static const float PI_id214 = 3.14159265358979323846;
struct PS_STREAMS 
{
    float4 ScreenPosition_id169;
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
    float4 Input_0_id185;
    float Input_1_id193;
    float Input_2_id202;
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
    uint2 lightData_id175;
    int lightIndex_id176;
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
    float4 ScreenPosition_id169 : SCREENPOSITION_ID169_SEM;
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
    float4 ScreenPosition_id169;
};
struct VS_OUTPUT 
{
    float4 PositionWS_id22 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float DepthVS_id23 : DEPTH_VS;
    float3 normalWS_id19 : NORMALWS;
    float4 ScreenPosition_id169 : SCREENPOSITION_ID169_SEM;
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
    float4 InputValue_id186;
    float InputValue_id194;
    float InputValue_id203;
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
    float NearClipPlane_id170 = 1.0f;
    float FarClipPlane_id171 = 100.0f;
    float2 ZProjection_id172;
    float2 ViewSize_id173;
    float AspectRatio_id174;
    float4 _padding_PerView_Default;
    int LightCount_id86;
    DirectionalLightData Lights_id88[TMaxLightCount_id87];
    int LightCount_id89;
    DirectionalLightData Lights_id91[TMaxLightCount_id90];
    float2 ShadowMapTextureSize_id93;
    float2 ShadowMapTextureTexelSize_id94;
    float4x4 WorldToShadowCascadeUV_id156[TCascadeCountBase_id154 * TLightCountBase_id155];
    float4x4 InverseWorldToShadowCascadeUV_id157[TCascadeCountBase_id154 * TLightCountBase_id155];
    float4x4 ViewMatrices_id158[TCascadeCountBase_id154 * TLightCountBase_id155];
    float2 DepthRanges_id159[TCascadeCountBase_id154 * TLightCountBase_id155];
    float DepthBiases_id160[TLightCountBase_id155];
    float OffsetScales_id161[TLightCountBase_id155];
    float CascadeDepthSplits_id168[TCascadeCount_id162 * TLightCount_id163];
    float ClusterDepthScale_id179;
    float ClusterDepthBias_id180;
    float2 ClusterStride_id181;
    float3 AmbientLight_id184;
    float4 _padding_PerView_Lighting;
};
cbuffer Globals 
{
    float2 Texture0TexelSize_id96;
    float2 Texture1TexelSize_id98;
    float2 Texture2TexelSize_id100;
    float2 Texture3TexelSize_id102;
    float2 Texture4TexelSize_id104;
    float2 Texture5TexelSize_id106;
    float2 Texture6TexelSize_id108;
    float2 Texture7TexelSize_id110;
    float2 Texture8TexelSize_id112;
    float2 Texture9TexelSize_id114;
};
Texture2D Texture0_id95;
Texture2D Texture1_id97;
Texture2D Texture2_id99;
Texture2D Texture3_id101;
Texture2D Texture4_id103;
Texture2D Texture5_id105;
Texture2D Texture6_id107;
Texture2D Texture7_id109;
Texture2D Texture8_id111;
Texture2D Texture9_id113;
TextureCube TextureCube0_id115;
TextureCube TextureCube1_id116;
TextureCube TextureCube2_id117;
TextureCube TextureCube3_id118;
Texture3D Texture3D0_id119;
Texture3D Texture3D1_id120;
Texture3D Texture3D2_id121;
Texture3D Texture3D3_id122;
SamplerState Sampler_id123;
SamplerState PointSampler_id124 
{
    Filter = MIN_MAG_MIP_POINT;
};
SamplerState LinearSampler_id125 
{
    Filter = MIN_MAG_MIP_LINEAR;
};
SamplerState LinearBorderSampler_id126 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Border;
    AddressV = Border;
};
SamplerComparisonState LinearClampCompareLessEqualSampler_id127 
{
    Filter = COMPARISON_MIN_MAG_LINEAR_MIP_POINT;
    AddressU = Clamp;
    AddressV = Clamp;
    ComparisonFunc = LessEqual;
};
SamplerState AnisotropicSampler_id128 
{
    Filter = ANISOTROPIC;
};
SamplerState AnisotropicRepeatSampler_id129 
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
    MaxAnisotropy = 16;
};
SamplerState PointRepeatSampler_id130 
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState LinearRepeatSampler_id131 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState RepeatSampler_id132 
{
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState Sampler0_id133;
SamplerState Sampler1_id134;
SamplerState Sampler2_id135;
SamplerState Sampler3_id136;
SamplerState Sampler4_id137;
SamplerState Sampler5_id138;
SamplerState Sampler6_id139;
SamplerState Sampler7_id140;
SamplerState Sampler8_id141;
SamplerState Sampler9_id142;
Texture2D EnvironmentLightingDFG_LUT_id215;
Texture2D ShadowMapTexture_id92;
Texture3D<uint2> LightClusters_id177;
Buffer<uint> LightIndices_id178;
Buffer<float4> PointLights_id182;
Buffer<float4> SpotLights_id183;
float SmoothDistanceAttenuation_id89(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float SmoothDistanceAttenuation_id78(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float4 Project_id63(float4 vec, float4x4 mat)
{
    float4 vecProjected = mul(vec, mat);
    vecProjected.xyz /= vecProjected.w;
    return vecProjected;
}
float GetAngularAttenuation_id91(float3 lightVector, float3 lightDirection, float lightAngleScale, float lightAngleOffset)
{
    float cd = dot(lightDirection, lightVector);
    float attenuation = saturate(cd * lightAngleScale + lightAngleOffset);
    attenuation *= attenuation;
    return attenuation;
}
float GetDistanceAttenuation_id90(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id89(d2, lightInvSquareRadius);
    return attenuation;
}
float GetDistanceAttenuation_id80(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id78(d2, lightInvSquareRadius);
    return attenuation;
}
float SampleThickness_id71(float3 shadowSpaceCoordinate, float3 pixelPositionWS, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float shadowMapDepth = ShadowMapTexture_id92.SampleLevel(LinearBorderSampler_id126, shadowSpaceCoordinate.xy, 0).r;
    float thickness;
    if (isOrthographic)
    {
        thickness = abs(shadowMapDepth - shadowSpaceCoordinate.z) * depthRanges.y;
    }
    else
    {
        float4 shadowmapPositionWorldSpace = Project_id63(float4(shadowSpaceCoordinate.xy, shadowMapDepth, 1.0), inverseWorldToShadowCascadeUV);
        thickness = distance(shadowmapPositionWorldSpace.xyz, pixelPositionWS.xyz);
    }
    return (thickness);
}
void CalculateAdjustedShadowSpacePixelPosition_id70(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    float4 bottomLeftTexelWS = Project_id63(float4(0.0, 0.0, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id63(float4(ShadowMapTextureTexelSize_id94.xy * filterRadiusInPixels, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, bottomLeftTexelWS.xyz);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 shadowMapCoordinate = Project_id63(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = shadowMapCoordinate.xyz;
}
void CalculateAdjustedShadowSpacePixelPositionPerspective_id69(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    const float4 shadowMapCoordinate = Project_id63(float4(pixelPositionWS, 1.0), worldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id63(float4(shadowMapCoordinate.xy + ShadowMapTextureTexelSize_id94.xy * filterRadiusInPixels, shadowMapCoordinate.z, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, pixelPositionWS);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 adjustedShadowMapCoordinate = Project_id63(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = adjustedShadowMapCoordinate.xyz;
}
float Compute_id267()
{
    return InputValue_id203;
}
float Compute_id255()
{
    return InputValue_id194;
}
float4 Compute_id243()
{
    return InputValue_id186;
}
float ComputeAttenuation_id92(float3 PositionWS, float3 AngleOffsetAndInvSquareRadius, float3 DirectionWS, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float3 lightAngleOffsetAndInvSquareRadius = AngleOffsetAndInvSquareRadius;
    float2 lightAngleAndOffset = lightAngleOffsetAndInvSquareRadius.xy;
    float lightInvSquareRadius = lightAngleOffsetAndInvSquareRadius.z;
    float3 lightDirection = -DirectionWS;
    float attenuation = GetDistanceAttenuation_id90(lightVectorLength, lightInvSquareRadius);
    attenuation *= GetAngularAttenuation_id91(lightVectorNorm, lightDirection, lightAngleAndOffset.x, lightAngleAndOffset.y);
    return attenuation;
}
float ComputeAttenuation_id79(PointLightDataInternal light, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = light.PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float lightInvSquareRadius = light.InvSquareRadius;
    return GetDistanceAttenuation_id80(lightVectorLength, lightInvSquareRadius);
}
float FilterThickness_id65(float3 pixelPositionWS, float3 meshNormalWS, float2 depthRanges, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float filterRadiusInPixels = 1.5;
    float3 adjustedPixelPositionWS;
    float3 adjustedPixelPositionShadowSpace;
    if (isOrthographic)
    {
        CalculateAdjustedShadowSpacePixelPosition_id70(filterRadiusInPixels, pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    else
    {
        CalculateAdjustedShadowSpacePixelPositionPerspective_id69(filterRadiusInPixels, pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    return SampleThickness_id71(adjustedPixelPositionShadowSpace, adjustedPixelPositionWS, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
}
float FilterShadow_id64(float2 position, float positionDepth)
{
    return ShadowMapTexture_id92.SampleCmpLevelZero(LinearClampCompareLessEqualSampler_id127, position, positionDepth);
}
float VisibilityhSchlickGGX_id155(float alphaR, float nDotX)
{
    float k = alphaR * 0.5f;
    return nDotX / (nDotX * (1.0f - k) + k);
}
float3 FresnelSchlick_id139(float3 f0, float3 f90, float lOrVDotH)
{
    return f0 + (f90 - f0) * pow((1 - lOrVDotH), 5);
}
void Compute_id270(inout PS_STREAMS streams)
{
    streams.Input_2_id202 = Compute_id267();
}
void Compute_id258(inout PS_STREAMS streams)
{
    streams.Input_1_id193 = Compute_id255();
}
void Compute_id246(inout PS_STREAMS streams)
{
    streams.Input_0_id185 = Compute_id243();
}
void ProcessLight_id93(inout PS_STREAMS streams, SpotLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id92(light.PositionWS, light.AngleOffsetAndInvSquareRadius, light.DirectionWS, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
void ProcessLight_id82(inout PS_STREAMS streams, PointLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id79(light, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightPositionWS_id41 = light.PositionWS;
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
float ComputeThicknessFromCascade_id68(float3 pixelPositionWS, float3 meshNormalWS, int cascadeIndex, int lightIndex, bool isOrthographic)
{
    const int arrayIndex = cascadeIndex + lightIndex * TCascadeCountBase_id154;
    return FilterThickness_id65(pixelPositionWS, meshNormalWS, DepthRanges_id159[arrayIndex], WorldToShadowCascadeUV_id156[arrayIndex], InverseWorldToShadowCascadeUV_id157[arrayIndex], isOrthographic);
}
float ComputeShadowFromCascade_id67(float3 shadowPositionWS, int cascadeIndex, int lightIndex)
{
    float4 shadowPosition = mul(float4(shadowPositionWS, 1.0), WorldToShadowCascadeUV_id156[cascadeIndex + lightIndex * TCascadeCountBase_id154]);
    shadowPosition.z -= DepthBiases_id160[lightIndex];
    shadowPosition.xyz /= shadowPosition.w;
    return FilterShadow_id64(shadowPosition.xy, shadowPosition.z);
}
float3 GetShadowPositionOffset_id66(float offsetScale, float nDotL, float3 normal)
{
    float normalOffsetScale = saturate(1.0f - nDotL);
    return 2.0f * ShadowMapTextureTexelSize_id94.x * offsetScale * normalOffsetScale * normal;
}
float NormalDistributionGGX_id169(float alphaR, float nDotH)
{
    float alphaR2 = alphaR * alphaR;
    float d = max(nDotH * nDotH * (alphaR2 - 1) + 1, 0.0001);
    return alphaR2 / (PI_id214 * d * d);
}
float VisibilitySmithSchlickGGX_id157(float alphaR, float nDotL, float nDotV)
{
    return VisibilityhSchlickGGX_id155(alphaR, nDotL) * VisibilityhSchlickGGX_id155(alphaR, nDotV) / (nDotL * nDotV);
}
float3 FresnelSchlick_id145(float3 f0, float lOrVDotH)
{
    return FresnelSchlick_id139(f0, 1.0f, lOrVDotH);
}
float Compute_id273(inout PS_STREAMS streams)
{
    return streams.Input_2_id202;
}
void Compute_id272(inout PS_STREAMS streams)
{

    {
        Compute_id270(streams);
    }
}
float Compute_id261(inout PS_STREAMS streams)
{
    return streams.Input_1_id193;
}
void Compute_id260(inout PS_STREAMS streams)
{

    {
        Compute_id258(streams);
    }
}
float4 Compute_id249(inout PS_STREAMS streams)
{
    return streams.Input_0_id185;
}
void Compute_id248(inout PS_STREAMS streams)
{

    {
        Compute_id246(streams);
    }
}
float3 Compute_id279(float3 specularColor, float alphaR, float nDotV)
{
    float glossiness = 1.0f - sqrt(alphaR);
    float4 environmentLightingDFG = EnvironmentLightingDFG_LUT_id215.SampleLevel(LinearSampler_id125, float2(glossiness, nDotV), 0);
    return specularColor * environmentLightingDFG.r + environmentLightingDFG.g;
}
void PrepareEnvironmentLight_id97(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeSpecularTextureProjection_id88(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id87(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id86(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id85(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id178.Load(streams.lightIndex_id176);
    streams.lightIndex_id176++;
    SpotLightDataInternal spotLight;
    float4 spotLight1 = SpotLights_id183.Load(realLightIndex * 4);
    float4 spotLight2 = SpotLights_id183.Load(realLightIndex * 4 + 1);
    float4 spotLight3 = SpotLights_id183.Load(realLightIndex * 4 + 2);
    float4 spotLight4 = SpotLights_id183.Load(realLightIndex * 4 + 3);
    spotLight.PositionWS = spotLight1.xyz;
    spotLight.DirectionWS = spotLight2.xyz;
    spotLight.AngleOffsetAndInvSquareRadius = spotLight3.xyz;
    spotLight.Color = spotLight4.xyz;
    ProcessLight_id93(streams, spotLight);
}
float3 ComputeSpecularTextureProjection_id77(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id76(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id75(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id74(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id178.Load(streams.lightIndex_id176);
    streams.lightIndex_id176++;
    PointLightDataInternal pointLight;
    float4 pointLight1 = PointLights_id182.Load(realLightIndex * 2);
    float4 pointLight2 = PointLights_id182.Load(realLightIndex * 2 + 1);
    pointLight.PositionWS = pointLight1.xyz;
    pointLight.InvSquareRadius = pointLight1.w;
    pointLight.Color = pointLight2.xyz;
    ProcessLight_id82(streams, pointLight);
}
void PrepareLightData_id81(inout PS_STREAMS streams)
{
    float projectedDepth = streams.ShadingPosition_id0.z;
    float depth = ZProjection_id172.y / (projectedDepth - ZProjection_id172.x);
    float2 texCoord = float2(streams.ScreenPosition_id169.x + 1, 1 - streams.ScreenPosition_id169.y) * 0.5;
    int slice = int(max(log2(depth * ClusterDepthScale_id179 + ClusterDepthBias_id180), 0));
    streams.lightData_id175 = LightClusters_id177.Load(int4(texCoord * ClusterStride_id181, slice, 0));
    streams.lightIndex_id176 = streams.lightData_id175.x;
}
float3 ComputeSpecularTextureProjection_id60(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id59(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id58(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    int cascadeIndexBase = lightIndex * TCascadeCount_id162;
    int cascadeIndex = 0;

    [unroll]
    for (int i = 0; i < TCascadeCount_id162 - 1; i++)
    {
        [flatten]
        if (streams.DepthVS_id23 > CascadeDepthSplits_id168[cascadeIndexBase + i])
        {
            cascadeIndex = i + 1;
        }
    }
    float3 shadow = 1.0;
    float tempThickness = 999.0;
    float3 shadowPosition = position.xyz;
    shadowPosition += GetShadowPositionOffset_id66(OffsetScales_id161[lightIndex], streams.NdotL_id49, streams.normalWS_id19);
    if (cascadeIndex < TCascadeCount_id162)
    {
        shadow = ComputeShadowFromCascade_id67(shadowPosition, cascadeIndex, lightIndex);
        float nextSplit = CascadeDepthSplits_id168[cascadeIndexBase + cascadeIndex];
        float splitSize = nextSplit;
        if (cascadeIndex > 0)
        {
            splitSize = nextSplit - CascadeDepthSplits_id168[cascadeIndexBase + cascadeIndex - 1];
        }
        float splitDist = (nextSplit - streams.DepthVS_id23) / splitSize;
        if (splitDist < 0.2)
        {
            float lerpAmt = smoothstep(0.0, 0.2, splitDist);
            if (cascadeIndex == TCascadeCount_id162 - 1)
            {
            }
            else if (TBlendCascades_id164)
            {
                float nextShadow = ComputeShadowFromCascade_id67(shadowPosition, cascadeIndex + 1, lightIndex);
                shadow = lerp(nextShadow, shadow, lerpAmt);
            }
        }
    }
    streams.thicknessWS_id85 = tempThickness;
    return shadow;
}
void PrepareDirectLightCore_id57(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id91[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id91[lightIndex].DirectionWS;
}
float Compute_id371(inout PS_STREAMS streams)
{
    return NormalDistributionGGX_id169(streams.alphaRoughness_id70, streams.NdotH_id76);
}
float Compute_id341(inout PS_STREAMS streams)
{
    return VisibilitySmithSchlickGGX_id157(streams.alphaRoughness_id70, streams.NdotL_id49, streams.NdotV_id72);
}
float3 Compute_id311(inout PS_STREAMS streams, float3 f0)
{
    return FresnelSchlick_id145(f0, streams.LdotH_id77);
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
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id51(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id88[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id88[lightIndex].DirectionWS;
}
float Compute_id276(inout PS_STREAMS streams)
{
    Compute_id272(streams);
    return Compute_id273(streams);
}
float Compute_id264(inout PS_STREAMS streams)
{
    Compute_id260(streams);
    return Compute_id261(streams);
}
float4 Compute_id252(inout PS_STREAMS streams)
{
    Compute_id248(streams);
    return Compute_id249(streams);
}
void ResetStream_id172()
{
}
void AfterLightingAndShading_id428()
{
}
void AfterLightingAndShading_id409()
{
}
void PrepareEnvironmentLight_id242(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeEnvironmentLightContribution_id458(inout PS_STREAMS streams)
{
    float3 specularColor = streams.matSpecularVisible_id71;
    return Compute_id279(specularColor, streams.alphaRoughness_id70, streams.NdotV_id72) * streams.envLightSpecularColor_id48;
}
float3 ComputeEnvironmentLightContribution_id402(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor * streams.envLightDiffuseColor_id47;
}
void PrepareEnvironmentLight_id239(inout PS_STREAMS streams)
{
    PrepareEnvironmentLight_id97(streams);
    float3 lightColor = AmbientLight_id184 * streams.matAmbientOcclusion_id57;
    streams.envLightDiffuseColor_id47 = lightColor;
    streams.envLightSpecularColor_id48 = lightColor;
}
void PrepareDirectLight_id230(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id85(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id86(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id87(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id88(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id234(inout PS_STREAMS streams)
{
    return streams.lightData_id175.y >> 16;
}
int GetMaxLightCount_id233(inout PS_STREAMS streams)
{
    return streams.lightData_id175.y >> 16;
}
void PrepareDirectLights_id228()
{
}
void PrepareDirectLight_id217(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id74(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id75(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id76(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id77(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id222(inout PS_STREAMS streams)
{
    return streams.lightData_id175.y & 0xFFFF;
}
int GetMaxLightCount_id221(inout PS_STREAMS streams)
{
    return streams.lightData_id175.y & 0xFFFF;
}
void PrepareDirectLights_id220(inout PS_STREAMS streams)
{
    PrepareLightData_id81(streams);
}
void PrepareDirectLight_id193(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id57(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id58(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id59(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id60(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id195()
{
    return LightCount_id89;
}
int GetMaxLightCount_id196()
{
    return TMaxLightCount_id90;
}
void PrepareDirectLights_id191()
{
}
float3 ComputeDirectLightContribution_id457(inout PS_STREAMS streams)
{
    float3 specularColor = streams.matSpecularVisible_id71;
    float3 fresnel = Compute_id311(streams, specularColor);
    float geometricShadowing = Compute_id341(streams);
    float normalDistribution = Compute_id371(streams);
    float3 reflected = fresnel * geometricShadowing * normalDistribution / 4;
    return reflected * streams.lightSpecularColorNdotL_id45 * streams.matDiffuseSpecularAlphaBlend_id65.y;
}
float3 ComputeDirectLightContribution_id401(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor / PI_id214 * streams.lightColorNdotL_id44 * streams.matDiffuseSpecularAlphaBlend_id65.x;
}
void PrepareMaterialPerDirectLight_id30(inout PS_STREAMS streams)
{
    streams.H_id75 = normalize(streams.viewWS_id68 + streams.lightDirectionWS_id42);
    streams.NdotH_id76 = saturate(dot(streams.normalWS_id19, streams.H_id75));
    streams.LdotH_id77 = saturate(dot(streams.lightDirectionWS_id42, streams.H_id75));
    streams.VdotH_id78 = streams.LdotH_id77;
}
void PrepareDirectLight_id182(inout PS_STREAMS streams, int lightIndex)
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
int GetLightCount_id184()
{
    return LightCount_id86;
}
int GetMaxLightCount_id185()
{
    return TMaxLightCount_id87;
}
void PrepareDirectLights_id180()
{
}
void PrepareForLightingAndShading_id425()
{
}
void PrepareForLightingAndShading_id406()
{
}
void PrepareMaterialForLightingAndShading_id171(inout PS_STREAMS streams)
{
    streams.lightDirectAmbientOcclusion_id50 = lerp(1.0, streams.matAmbientOcclusion_id57, streams.matAmbientOcclusionDirectLightingFactor_id58);
    streams.matDiffuseVisible_id69 = streams.matDiffuse_id53.rgb * lerp(1.0f, streams.matCavity_id59, streams.matCavityDiffuse_id60) * streams.matDiffuseSpecularAlphaBlend_id65.r * streams.matAlphaBlendColor_id66;
    streams.matSpecularVisible_id71 = streams.matSpecular_id55.rgb * streams.matSpecularIntensity_id56 * lerp(1.0f, streams.matCavity_id59, streams.matCavitySpecular_id61) * streams.matDiffuseSpecularAlphaBlend_id65.g * streams.matAlphaBlendColor_id66;
    streams.NdotV_id72 = max(dot(streams.normalWS_id19, streams.viewWS_id68), 0.0001f);
    float roughness = 1.0f - streams.matGlossiness_id54;
    streams.alphaRoughness_id70 = max(roughness * roughness, 0.001);
}
void ResetLightStream_id170(inout PS_STREAMS streams)
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
float4 Compute_id278(inout PS_STREAMS streams)
{
    float x = Compute_id276(streams);
    return float4(x, x, x, x);
}
float4 Compute_id266(inout PS_STREAMS streams)
{
    float x = Compute_id264(streams);
    return float4(x, x, x, x);
}
float4 Compute_id254(inout PS_STREAMS streams)
{
    return Compute_id252(streams);
}
void ResetStream_id173(inout PS_STREAMS streams)
{
    ResetStream_id172();
    streams.matBlend_id40 = 0.0f;
}
void Compute_id489(inout PS_STREAMS streams)
{
    UpdateNormalFromTangentSpace_id23(streams.matNormal_id51);
    if (!streams.IsFrontFace_id1)
        streams.normalWS_id19 = -streams.normalWS_id19;
    ResetLightStream_id170(streams);
    PrepareMaterialForLightingAndShading_id171(streams);

    {
        PrepareForLightingAndShading_id406();
    }

    {
        PrepareForLightingAndShading_id425();
    }
    float3 directLightingContribution = 0;

    {
        PrepareDirectLights_id180();
        const int maxLightCount = GetMaxLightCount_id185();
        int count = GetLightCount_id184();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id182(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id401(streams);
            }

            {
                directLightingContribution += ComputeDirectLightContribution_id457(streams);
            }
        }
    }

    {
        PrepareDirectLights_id191();
        const int maxLightCount = GetMaxLightCount_id196();
        int count = GetLightCount_id195();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id193(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id401(streams);
            }

            {
                directLightingContribution += ComputeDirectLightContribution_id457(streams);
            }
        }
    }

    {
        PrepareDirectLights_id220(streams);
        const int maxLightCount = GetMaxLightCount_id221(streams);
        int count = GetLightCount_id222(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id217(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id401(streams);
            }

            {
                directLightingContribution += ComputeDirectLightContribution_id457(streams);
            }
        }
    }

    {
        PrepareDirectLights_id228();
        const int maxLightCount = GetMaxLightCount_id233(streams);
        int count = GetLightCount_id234(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id230(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id401(streams);
            }

            {
                directLightingContribution += ComputeDirectLightContribution_id457(streams);
            }
        }
    }
    float3 environmentLightingContribution = 0;

    {
        PrepareEnvironmentLight_id239(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id402(streams);
        }

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id458(streams);
        }
    }

    {
        PrepareEnvironmentLight_id242(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id402(streams);
        }

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id458(streams);
        }
    }
    streams.shadingColor_id73 += directLightingContribution * PI_id214 + environmentLightingContribution;
    streams.shadingColorAlpha_id74 = streams.matDiffuse_id53.a;

    {
        AfterLightingAndShading_id409();
    }

    {
        AfterLightingAndShading_id428();
    }
}
void Compute_id473(inout PS_STREAMS streams)
{
    float metalness = Compute_id278(streams).r;
    streams.matSpecular_id55 = lerp(0.02, streams.matDiffuse_id53.rgb, metalness);
    streams.matDiffuse_id53.rgb = lerp(streams.matDiffuse_id53.rgb, 0, metalness);
}
void Compute_id468(inout PS_STREAMS streams)
{
    float glossiness = Compute_id266(streams).r;

    {
        glossiness = 1.0 - glossiness;
    }
    streams.matGlossiness_id54 = glossiness;
}
void Compute_id463(inout PS_STREAMS streams)
{
    float4 colorBase = Compute_id254(streams);
    streams.matDiffuse_id53 = colorBase;
    streams.matColorBase_id52 = colorBase;
}
void ResetStream_id174(inout PS_STREAMS streams)
{
    ResetStream_id173(streams);
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
        Compute_id463(streams);
    }

    {
        Compute_id468(streams);
    }

    {
        Compute_id473(streams);
    }

    {
        Compute_id489(streams);
    }
}
void ResetStream_id47(inout PS_STREAMS streams)
{
    ResetStream_id174(streams);
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
    streams.ScreenPosition_id169 = __input__.ScreenPosition_id169;
    streams.IsFrontFace_id1 = __input__.IsFrontFace_id1;
    streams.ScreenPosition_id169 /= streams.ScreenPosition_id169.w;
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
    streams.ScreenPosition_id169 = streams.ShadingPosition_id0;
    VS_OUTPUT __output__ = (VS_OUTPUT)0;
    __output__.PositionWS_id22 = streams.PositionWS_id22;
    __output__.ShadingPosition_id0 = streams.ShadingPosition_id0;
    __output__.DepthVS_id23 = streams.DepthVS_id23;
    __output__.normalWS_id19 = streams.normalWS_id19;
    __output__.ScreenPosition_id169 = streams.ScreenPosition_id169;
    return __output__;
}
