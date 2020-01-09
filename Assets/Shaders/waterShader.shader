// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "waterShader"
{
	Properties
	{
		_tesselation("tesselation", Float) = 3
		_waveheight("wave height", Range( 0 , 1)) = 0
		_wavespeed("wave speed", Range( 0 , 1)) = 0.13
		_vertexpanningspeed("vertex panning speed", Range( 0 , 1)) = 0
		_maintex("main tex", 2D) = "white" {}
		_maintexcolorcontrol("main tex color control", Color) = (1,1,1,0)
		_backtex("back tex", 2D) = "white" {}
		_foamopacity("foam opacity", Range( 0 , 1)) = 0
		_foammaincolor("foam main color", Color) = (1,0,0,0)
		_foamsecondarycolor("foam secondary color", Color) = (1,0,0,0)
		_opacitycontrol("opacity control", Range( 0 , 1)) = 0
		_metallicness("metallicness", Range( 0 , 1)) = 0
		_smoothness("smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _wavespeed;
		uniform float _vertexpanningspeed;
		uniform float _waveheight;
		uniform float4 _maintexcolorcontrol;
		uniform sampler2D _maintex;
		uniform float4 _maintex_ST;
		uniform sampler2D _backtex;
		uniform float4 _backtex_ST;
		uniform float4 _foammaincolor;
		uniform float4 _foamsecondarycolor;
		uniform float _foamopacity;
		uniform float _metallicness;
		uniform float _smoothness;
		uniform float _opacitycontrol;
		uniform float _tesselation;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_2 = (_tesselation).xxxx;
			return temp_cast_2;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = ((0.0 + (_wavespeed - 0.0) * (10.0 - 0.0) / (1.0 - 0.0))).xx;
			float2 uv_TexCoord46 = v.texcoord.xy * float2( 10,2 );
			float2 panner48 = ( 1.0 * _Time.y * temp_cast_0 + uv_TexCoord46);
			float simplePerlin2D47 = snoise( ( panner48 + ( _SinTime.x * (0.0 + (_vertexpanningspeed - 0.0) * (10.0 - 0.0) / (1.0 - 0.0)) ) ) );
			float3 temp_cast_1 = ((( _waveheight * -1.0 ) + (simplePerlin2D47 - 0.0) * (_waveheight - ( _waveheight * -1.0 )) / (1.0 - 0.0))).xxx;
			v.vertex.xyz += temp_cast_1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_maintex = i.uv_texcoord * _maintex_ST.xy + _maintex_ST.zw;
			float2 panner165 = ( 0.5 * _Time.y * float2( 0.01,0.01 ) + uv0_maintex);
			float cos202 = cos( 0.05 * _Time.y );
			float sin202 = sin( 0.05 * _Time.y );
			float2 rotator202 = mul( panner165 - float2( 0,0 ) , float2x2( cos202 , -sin202 , sin202 , cos202 )) + float2( 0,0 );
			float3 desaturateInitialColor174 = tex2D( _maintex, rotator202 ).rgb;
			float desaturateDot174 = dot( desaturateInitialColor174, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar174 = lerp( desaturateInitialColor174, desaturateDot174.xxx, -2.0 );
			float2 uv0_backtex = i.uv_texcoord * _backtex_ST.xy + _backtex_ST.zw;
			float2 panner141 = ( 1.0 * _Time.y * float2( 0.01,0 ) + uv0_backtex);
			float2 uv_TexCoord83 = i.uv_texcoord * float2( 20,20 );
			float2 panner86 = ( 0.5 * _Time.y * float2( 0.1,0 ) + uv_TexCoord83);
			float cos201 = cos( 0.0001 * _Time.y );
			float sin201 = sin( 0.0001 * _Time.y );
			float2 rotator201 = mul( panner86 - float2( 0,0 ) , float2x2( cos201 , -sin201 , sin201 , cos201 )) + float2( 0,0 );
			float simplePerlin3D91 = snoise( float3( ( rotator201 + float2( 0,0 ) ) ,  0.0 ) );
			float mulTime187 = _Time.y * 3.0;
			float lerpResult188 = lerp( mulTime187 , _Time.y , 0.0);
			float4 lerpResult106 = lerp( _foammaincolor , _foamsecondarycolor , saturate( ( (( _foamopacity * (0.1 + (sin( lerpResult188 ) - 0.0) * (0.2 - 0.1) / (1.0 - 0.0)) ) + (simplePerlin3D91 - 0.0) * (_foamopacity - ( _foamopacity * (0.1 + (sin( lerpResult188 ) - 0.0) * (0.2 - 0.1) / (1.0 - 0.0)) )) / (1.0 - 0.0)) + 0.0 ) ));
			o.Albedo = ( ( ( _maintexcolorcontrol * float4( desaturateVar174 , 0.0 ) ) * tex2D( _backtex, panner141 ) ) + lerpResult106 ).rgb;
			o.Metallic = _metallicness;
			o.Smoothness = _smoothness;
			o.Alpha = _opacitycontrol;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
62;401;1314;764;1910.354;324.6558;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;79;-1622.024,-191.3221;Float;False;1247.14;582.9891;panning of the main noise;21;179;190;185;188;187;89;184;154;153;155;136;95;92;90;91;88;86;83;182;181;201;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-1471.248,-114.8584;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;20,20;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;190;-1576.981,239.6385;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;187;-1580.007,174.0803;Float;False;1;0;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;188;-1400.479,206.3551;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;86;-1250.65,-114.4993;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;201;-1083.733,-151.2646;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0.0001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;185;-1249.19,214.4238;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;184;-1128.16,198.2865;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;162;-1421.484,-1574.378;Float;False;1024.049;358.7648;texture;5;166;165;164;163;202;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1064.445,-33.8362;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1571.511,316.287;Float;False;Property;_foamopacity;foam opacity;12;0;Create;True;0;0;False;0;0;0.21;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;163;-1371.484,-1524.378;Float;True;Property;_maintex;main tex;8;0;Create;True;0;0;False;0;a84c7a7a347c2bb4aa8416ed0cb6c7c6;558302d739b7abc4db986d2aff8e7644;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-942.0549,191.2055;Float;False;2;2;0;FLOAT;-1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;91;-851.1492,-63.96437;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;92;-802.9873,163.8353;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;-1623.434,403.5892;Float;False;1428.324;516.7715;panning of the vertex offset;15;53;54;52;77;78;74;76;75;67;48;46;68;47;198;199;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;164;-1187.711,-1328.658;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-1604.532,780.0616;Float;False;Property;_vertexpanningspeed;vertex panning speed;4;0;Create;True;0;0;False;0;0;0.224;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;165;-919.2987,-1371.613;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.01,0.01;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-1617.736,472.3002;Float;False;Property;_wavespeed;wave speed;3;0;Create;True;0;0;False;0;0.13;0.115;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;158;-1405.156,-1093.094;Float;False;1024.049;358.7648;texture;4;140;139;141;138;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-643.822,-62.73054;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;140;-1355.156,-1043.094;Float;True;Property;_backtex;back tex;10;0;Create;True;0;0;False;0;558302d739b7abc4db986d2aff8e7644;a84c7a7a347c2bb4aa8416ed0cb6c7c6;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RotatorNode;202;-748.4366,-1331.698;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;136;-541.1793,162.785;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;67;-1186.625,609.9913;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-1335.908,425.4578;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;75;-1376.608,580.6163;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;78;-1265.412,743.138;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;196;-370.2429,-1698.541;Float;False;770.7517;470.5674;main tex color saturation;4;175;174;178;176;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;155;-408.9844,167.108;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;139;-1121.383,-891.3747;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1046.348,595.4973;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;166;-724.4355,-1516.603;Float;True;Property;_TextureSample4;Texture Sample 4;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;48;-1088.877,453.4119;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-320.2429,-1426.724;Float;False;Constant;_Float3;Float 3;16;0;Create;True;0;0;False;0;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-997.9843,769.9732;Float;False;Property;_waveheight;wave height;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;174;-140.4911,-1480.974;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-849.9247,453.8686;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;178;-131.2322,-1648.541;Float;False;Property;_maintexcolorcontrol;main tex color control;9;0;Create;True;0;0;False;0;1,1,1,0;0.4389462,0.6616318,0.6792453,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;111;-948.5562,-706.7872;Float;False;570.7771;512.5089;water color;3;107;94;106;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-735.2114,658.0259;Float;False;2;2;0;FLOAT;-1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;153;-438.3905,-107.5485;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;141;-901.9704,-890.3297;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.01,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;154;-654.5046,-162.3866;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;199;-466.0697,673.4852;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;138;-708.1072,-1035.319;Float;True;Property;_TextureSample3;Texture Sample 3;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;165.5089,-1574.974;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;47;-641.3557,463.1892;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;198;-430.8547,678.1805;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;107;-898.5562,-428.9775;Float;False;Property;_foamsecondarycolor;foam secondary color;15;0;Create;True;0;0;False;0;1,0,0,0;0.9811321,0.9811321,0.9811321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;94;-898.5856,-648.7872;Float;False;Property;_foammaincolor;foam main color;14;0;Create;True;0;0;False;0;1,0,0,0;0.250356,0.4774831,0.5471698,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;195;428.2902,-229.9694;Float;False;327;164;metallicness;1;191;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;193;373.9984,113.7075;Float;False;352;165;opacity;1;156;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;381.6198,-1172.797;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;194;423.2902,-54.96936;Float;False;342;158;smoothness;1;192;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;106;-616.7792,-446.2782;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;52;-389.8027,471.4251;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;73;645.7241,423.1661;Float;False;225;165;tessellation;1;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2101.04,3272.899;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;11;-1852.79,3277.514;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-1626.224,2805.55;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;b98082030f9fba44683b03679b5e625c;b98082030f9fba44683b03679b5e625c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-1592.109,2556.815;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;7;-657.2295,3981.462;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-1653.292,3210.621;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;b98082030f9fba44683b03679b5e625c;b98082030f9fba44683b03679b5e625c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-1208.163,3730.94;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;192;473.2902,-4.96936;Float;False;Property;_smoothness;smoothness;18;0;Create;True;0;0;False;0;0;0.72;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-445.0089,4212.764;Float;False;Property;_vertexoffsetcontroller;vertex offset controller;1;0;Create;True;0;0;False;0;0;0.01311493;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-808.8159,2535.716;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;31;-1057.182,2464.976;Float;True;Property;_maintexture;main texture;11;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.VertexColorNode;8;-1206.683,3563.44;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-914.0232,4015.888;Float;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-982.9088,3657.318;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-265.7873,3186.457;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-454.8432,3890.799;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;13;-654.6075,3636.242;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-798.2487,2769.177;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-2349.406,3202.158;Float;True;Property;_noise2;noise 2;7;0;Create;True;0;0;False;0;a6145df3f5a44b943b21d9438359d201;a6145df3f5a44b943b21d9438359d201;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;6;-1827.721,2884.442;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;30;-23.74361,2913.799;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-359.0688,2461.439;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;b98082030f9fba44683b03679b5e625c;b98082030f9fba44683b03679b5e625c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;695.7241,473.1661;Float;False;Property;_tesselation;tesselation;0;0;Create;True;0;0;False;0;3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;21;-134.5168,3735.77;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;423.9984,163.7075;Float;False;Property;_opacitycontrol;opacity control;16;0;Create;True;0;0;False;0;0;0.788;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;182;-1253.385,10.10274;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;45;False;4;FLOAT;52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-2721.915,3060.269;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;22;-280.7646,2918.997;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;35;-560.0328,2550.721;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;138.2421,3174.524;Float;False;2;2;0;FLOAT;-1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-1623.842,3016.92;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2075.971,2879.827;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-1934.594,3018.235;Float;False;Property;_Noisecontroller;Noise controller;5;0;Create;True;0;0;False;0;1;2.54;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;36;338.2116,3155.009;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;181;-1590.581,21.20833;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;15.02861,2471.393;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;10;-702.2324,3816.54;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2324.338,2809.087;Float;True;Property;_noise1;noise 1;6;0;Create;True;0;0;False;0;b98082030f9fba44683b03679b5e625c;b98082030f9fba44683b03679b5e625c;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;43;-1580.688,3448.706;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-749.1876,3087.049;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-150.5598,3346.491;Float;False;Property;_Float1;Float 1;13;0;Create;True;0;0;False;0;0;0.01311493;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;742.0033,-1071.423;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;197;752.2355,280.3336;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;477.2902,-179.9694;Float;False;Property;_metallicness;metallicness;17;0;Create;True;0;0;False;0;0;0.106;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-292.9157,3737.253;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;27;103.7978,3992.489;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1316.273,3020.81;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;179;-1419.478,-0.9766529;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;29;-3002.031,3021.484;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-156.2069,4040.797;Float;False;2;2;0;FLOAT;-1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;967.1473,-120.1363;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;waterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0;True;True;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.07;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;188;0;187;0
WireConnection;188;1;190;0
WireConnection;86;0;83;0
WireConnection;201;0;86;0
WireConnection;185;0;188;0
WireConnection;184;0;185;0
WireConnection;88;0;201;0
WireConnection;90;0;89;0
WireConnection;90;1;184;0
WireConnection;91;0;88;0
WireConnection;92;0;91;0
WireConnection;92;3;90;0
WireConnection;92;4;89;0
WireConnection;164;2;163;0
WireConnection;165;0;164;0
WireConnection;95;0;92;0
WireConnection;202;0;165;0
WireConnection;136;0;95;0
WireConnection;75;0;74;0
WireConnection;78;0;77;0
WireConnection;155;0;136;0
WireConnection;139;2;140;0
WireConnection;76;0;67;1
WireConnection;76;1;78;0
WireConnection;166;0;163;0
WireConnection;166;1;202;0
WireConnection;48;0;46;0
WireConnection;48;2;75;0
WireConnection;174;0;166;0
WireConnection;174;1;175;0
WireConnection;68;0;48;0
WireConnection;68;1;76;0
WireConnection;54;0;53;0
WireConnection;153;0;155;0
WireConnection;141;0;139;0
WireConnection;154;0;153;0
WireConnection;199;0;54;0
WireConnection;138;0;140;0
WireConnection;138;1;141;0
WireConnection;176;0;178;0
WireConnection;176;1;174;0
WireConnection;47;0;68;0
WireConnection;198;0;53;0
WireConnection;170;0;176;0
WireConnection;170;1;138;0
WireConnection;106;0;94;0
WireConnection;106;1;107;0
WireConnection;106;2;154;0
WireConnection;52;0;47;0
WireConnection;52;3;199;0
WireConnection;52;4;198;0
WireConnection;4;2;2;0
WireConnection;11;0;4;0
WireConnection;12;0;1;0
WireConnection;12;1;6;0
WireConnection;41;0;6;0
WireConnection;7;0;3;0
WireConnection;15;0;2;0
WireConnection;15;1;11;0
WireConnection;32;2;31;0
WireConnection;14;0;8;1
WireConnection;14;1;9;2
WireConnection;16;0;10;1
WireConnection;16;1;7;0
WireConnection;44;0;41;0
WireConnection;44;1;43;0
WireConnection;6;0;5;0
WireConnection;30;0;22;0
WireConnection;30;1;23;0
WireConnection;34;0;31;0
WireConnection;34;1;35;0
WireConnection;21;0;17;0
WireConnection;182;0;179;0
WireConnection;25;0;29;2
WireConnection;22;0;19;0
WireConnection;35;0;32;0
WireConnection;37;0;38;0
WireConnection;24;0;28;0
WireConnection;5;2;1;0
WireConnection;36;0;30;0
WireConnection;36;3;37;0
WireConnection;36;4;38;0
WireConnection;33;0;34;0
WireConnection;43;0;11;0
WireConnection;19;0;41;0
WireConnection;19;1;43;0
WireConnection;19;2;14;0
WireConnection;157;0;170;0
WireConnection;157;1;106;0
WireConnection;197;0;52;0
WireConnection;17;0;13;0
WireConnection;17;1;16;0
WireConnection;27;0;21;0
WireConnection;27;3;20;0
WireConnection;27;4;18;0
WireConnection;26;1;24;0
WireConnection;179;0;181;0
WireConnection;20;0;18;0
WireConnection;0;0;157;0
WireConnection;0;3;191;0
WireConnection;0;4;192;0
WireConnection;0;9;156;0
WireConnection;0;11;197;0
WireConnection;0;14;40;0
ASEEND*/
//CHKSM=BFA2C9EA4573F857F86CA758837E04FAA8F15C7D