Shader "MineselfShader/VFX/12-Particle/CustomData"
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
            sampler2D _DissolveTex; float4 _DissolveTex_ST;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 params : TEXCOORD1;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 params : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                //uv1---����������
                //params.xy�ṩ��λ�ƹ���
                //params.z�ṩ�����Ź���
                o.uv = (v.uv - 0.5) * v.params.z + 0.5;//��Ҫ��[-0.5,0.5]������½�������
                o.uv = o.uv - v.params.xy;
                //uv2---�����ܽ�
                o.uv2 = TRANSFORM_TEX(v.uv, _DissolveTex);

                o.params = v.params;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                float dissolveMask = tex2D(_DissolveTex, i.uv2);

                float3 finalRGB = mainTex.rgb;
                float alpha = step(dissolveMask, i.params.w) * mainTex.a;//params.w�ṩ�ܽ⹦��

                return float4(mainTex.rgb, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}