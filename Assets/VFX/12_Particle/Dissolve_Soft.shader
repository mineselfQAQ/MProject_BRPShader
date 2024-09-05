Shader "MineselfShader/VFX/12-Particle/Dissolve_Soft"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _DissolveTex("DissolveTexture", 2D) = "white"{}
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
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex;
            sampler2D _DissolveTex;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float params : TEXCOORD1;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : TEXCOORD1;
                float params : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.color = v.color;
                o.params = v.params;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                float3 finalRGB = mainTex * i.color;

                //���ܽ��㷨
                float dissolveTex = tex2D(_DissolveTex, i.uv);
                dissolveTex += 1 + i.params * -2;
                dissolveTex = saturate(dissolveTex);
                float alpha = mainTex.a * i.color.a * dissolveTex;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}