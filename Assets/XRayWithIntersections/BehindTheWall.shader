// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BehindTheWall"
{
	Properties
	{
		_XRayPower("XRayPower", Float) = 0
		_XRayColor("XRayColor", Color) = (0.03448248,0,1,1)
		_XRayScale("XRayScale", Float) = 0
		_XRayBias("XRayBias", Float) = 0
	}
	
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100
		
		Pass
		{
			Name "MAINPASS"
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Back
			ColorMask RGBA
			ZWrite Off
			ZTest Greater
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform float4 _XRayColor;
			uniform float _XRayBias;
			uniform float _XRayScale;
			uniform float _XRayPower;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float fresnelNdotV7 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode7 = ( _XRayBias + _XRayScale * pow( 1.0 - fresnelNdotV7, _XRayPower ) );
				float4 appendResult9 = (float4((_XRayColor).rgb , fresnelNode7));
				
				
				finalColor = appendResult9;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15405
242;100;1082;722;1383.581;657.5858;1.3;True;False
Node;AmplifyShaderEditor.ColorNode;2;-808.9871,-493.1218;Float;False;Property;_XRayColor;XRayColor;1;0;Create;True;0;0;False;0;0.03448248,0,1,1;0.03448248,0,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-748.0651,-137.8711;Float;False;Property;_XRayScale;XRayScale;2;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-734.9487,-243.0778;Float;False;Property;_XRayBias;XRayBias;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-696.6003,-62.85048;Float;False;Property;_XRayPower;XRayPower;0;0;Create;True;0;0;False;0;0;1.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-425.8788,-401.2;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;7;-484.3225,-223.8025;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-139.1235,-326.8928;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;11;60.62753,-321.349;Float;False;True;2;Float;ASEMaterialInspector;0;10;BehindTheWall;88d4695f530db2a46ae0f0a37e3684b4;0;0;MAINPASS;2;False;False;False;False;False;False;False;False;True;2;RenderType=Transparent;Queue=Transparent;False;0;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;2;False;-1;True;False;0;False;-1;0;False;-1;False;True;2;0;;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;10;0;2;0
WireConnection;7;1;1;0
WireConnection;7;2;4;0
WireConnection;7;3;3;0
WireConnection;9;0;10;0
WireConnection;9;3;7;0
WireConnection;11;0;9;0
ASEEND*/
//CHKSM=AA81E54021F42E5039C1F414EE7B1540D52E34AB