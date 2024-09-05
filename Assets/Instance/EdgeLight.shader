Shader "MineselfShader/Instance/EdgeLight"
{
    Properties
    {
        _NoiseTex("NoiseTexture", 2D) = "white"{}
        _FresnelPow("FresnelPow", Range(0, 10)) = 3
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        _Speed("Speed", vector) = (1,1,0,0)
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            ZWrite Off
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _NoiseTex; float4 _NoiseTex_ST;
            float _FresnelPow;
            fixed4 _Color;
            float2 _Speed;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _NoiseTex) + frac(_Speed * _Time.x);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float noiseMask = tex2D(_NoiseTex, i.uv);

                //�����������
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //����Fresnel
                float fresnel = pow(1 - saturate(dot(vDir, i.wNormal)), _FresnelPow);

                float3 finalRGB = fresnel * noiseMask * _Color;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}