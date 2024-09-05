Shader "MineselfShader/Test/NormalMap"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [Normal]_NormalMap("NormalMap", 2D) = "bump"{}
        _Int("Intensity", Float) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex;
            sampler2D _NormalMap;
            float _Int;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3x3 tbn : TEXCOORD1;
                float2 uv : TEXCOORD04;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;

                float3 nDir = UnityObjectToWorldNormal(v.normal);
                float3 tDir = UnityObjectToWorldDir(v.tangent.xyz);
                float3 bDir = cross(nDir, tDir) * v.tangent.w * unity_WorldTransformParams.w;

                o.tbn = float3x3(tDir, bDir, nDir);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 localNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                localNormal.xy *= _Int;
                float3 nDir = normalize(mul(localNormal, i.tbn));


                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
                float4 mainTex = tex2D(_MainTex, i.uv);
                
                float3 ambient = unity_AmbientSky;
                float3 diffuse = saturate(dot(lDir, nDir));
                float3 specular = pow(saturate(dot(rlDir, vDir)), 30) ;

                float3 finalRGB = ambient * mainTex + diffuse * mainTex + specular;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}