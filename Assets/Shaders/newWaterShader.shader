// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "newWaterShader"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Saturation("Saturation", Range( 0 , 1)) = 0
		_Textureoffset("Texture offset", Range( 0 , 1)) = 1
		_textureoffset2("texture offset 2", Range( 0 , 1)) = 1
		_time("time", Range( 0 , 1)) = 1
		_time2("time 2", Range( 0 , 1)) = 1
		_maincolorregulation("main color regulation", Color) = (1,1,1,0)
		_secondtexturecolorregulation("second texture color regulation", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _maincolorregulation;
		uniform sampler2D _MainTexture;
		uniform float _Textureoffset;
		uniform float _time;
		uniform float _Saturation;
		uniform float4 _secondtexturecolorregulation;
		uniform sampler2D _Texture0;
		uniform float _textureoffset2;
		uniform float _time2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime27 = _Time.y * _time;
			float2 temp_cast_0 = (( (0.0*15.0 + (1.0 + (_Textureoffset - 0.0) * (40.0 - 1.0) / (1.0 - 0.0))) * (0.4 + (sin( mulTime27 ) - 0.0) * (0.5 - 0.4) / (1.0 - 0.0)) )).xx;
			float2 uv_TexCoord2 = i.uv_texcoord * temp_cast_0;
			float2 panner4 = ( 1.0 * _Time.y * float2( 0,0.3 ) + uv_TexCoord2);
			float3 desaturateInitialColor6 = ( _maincolorregulation * tex2D( _MainTexture, panner4 ) ).rgb;
			float desaturateDot6 = dot( desaturateInitialColor6, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar6 = lerp( desaturateInitialColor6, desaturateDot6.xxx, (-10.0 + (_Saturation - 0.0) * (1.0 - -10.0) / (1.0 - 0.0)) );
			float mulTime54 = _Time.y * _time2;
			float2 temp_cast_3 = (( (0.0*15.0 + (1.0 + (_textureoffset2 - 0.0) * (40.0 - 1.0) / (1.0 - 0.0))) * (0.4 + (sin( mulTime54 ) - 0.0) * (0.5 - 0.4) / (1.0 - 0.0)) )).xx;
			float2 uv_TexCoord32 = i.uv_texcoord * temp_cast_3;
			float2 panner33 = ( 1.0 * _Time.y * float2( 0,0.3 ) + uv_TexCoord32);
			float4 temp_output_44_0 = ( float4( desaturateVar6 , 0.0 ) * ( _secondtexturecolorregulation * tex2D( _Texture0, panner33 ) ) );
			o.Albedo = temp_output_44_0.rgb;
			o.Emission = temp_output_44_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
282;434;1235;533;542.6652;148.0916;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;28;-2001.188,220.1999;Float;False;Property;_time;time;5;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1949.92,26.14669;Float;False;Property;_Textureoffset;Texture offset;3;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-1649.125,222.5686;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2145.365,1203.156;Float;False;Property;_time2;time 2;6;0;Create;True;0;0;False;0;1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;54;-1793.301,1205.525;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;24;-1472.63,167.2218;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-1656.721,28.02657;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;40;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2094.097,1009.103;Float;False;Property;_textureoffset2;texture offset 2;4;0;Create;True;0;0;False;0;1;0.99;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-1796.507,1024.564;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;40;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;56;-1616.806,1150.178;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;29;-1294.26,90.10455;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.4;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;17;-1497.929,-142.3219;Float;False;3;0;FLOAT;0;False;1;FLOAT;15;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1286.908,-92.78857;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;59;-1438.436,1073.061;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.4;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;58;-1610.007,853.8512;Float;False;3;0;FLOAT;0;False;1;FLOAT;15;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1372.553,914.7133;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1073.505,-180.6071;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1203.458,786.1335;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1440.655,-348.8451;Float;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;False;0;1e6b0d0ca52dc194eb1128ce0e05910e;1e6b0d0ca52dc194eb1128ce0e05910e;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;4;-859.176,-183.0204;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;33;-975.5844,782.2001;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;30;-706.3079,-587.579;Float;False;Property;_maincolorregulation;main color regulation;7;0;Create;True;0;0;False;0;1,1,1,0;0,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-696.3313,-337.6693;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;34;-1517.167,584.695;Float;True;Property;_Texture0;Texture 0;1;0;Create;True;0;0;False;0;1e6b0d0ca52dc194eb1128ce0e05910e;1e6b0d0ca52dc194eb1128ce0e05910e;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-942.1268,48.06942;Float;False;Property;_Saturation;Saturation;2;0;Create;True;0;0;False;0;0;0.634;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;11;-605.4419,-121.6709;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-10;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-669.7941,353.7561;Float;False;Property;_secondtexturecolorregulation;second texture color regulation;8;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-659.8174,603.6656;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-384.422,-476.6084;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;6;-287.8079,-218.9193;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-347.9078,464.7266;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-13.17006,158.9295;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;260.9191,9.846004;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;newWaterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;28;0
WireConnection;54;0;53;0
WireConnection;24;0;27;0
WireConnection;20;0;19;0
WireConnection;57;0;55;0
WireConnection;56;0;54;0
WireConnection;29;0;24;0
WireConnection;17;2;20;0
WireConnection;26;0;17;0
WireConnection;26;1;29;0
WireConnection;59;0;56;0
WireConnection;58;2;57;0
WireConnection;60;0;58;0
WireConnection;60;1;59;0
WireConnection;2;0;26;0
WireConnection;32;0;60;0
WireConnection;4;0;2;0
WireConnection;33;0;32;0
WireConnection;1;0;3;0
WireConnection;1;1;4;0
WireConnection;11;0;7;0
WireConnection;35;0;34;0
WireConnection;35;1;33;0
WireConnection;31;0;30;0
WireConnection;31;1;1;0
WireConnection;6;0;31;0
WireConnection;6;1;11;0
WireConnection;37;0;36;0
WireConnection;37;1;35;0
WireConnection;44;0;6;0
WireConnection;44;1;37;0
WireConnection;0;0;44;0
WireConnection;0;2;44;0
ASEEND*/
//CHKSM=F548DED8E0E264086F01C16C0F1E5AF8800243D9