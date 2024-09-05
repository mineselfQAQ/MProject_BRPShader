Shader "MineselfShader/VFX/12-Particle/RandomColorTest"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Oscilate("Oscilate", vector) = (1,1,1,0)
        _Phase("Phase", vector) = (0,0.33,0.67,0)
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
            float4 _Oscilate;
            float4 _Phase;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
             
                //��ʽ---y = a + b * cos(2�� * (c * x + d))
                //_Oscilate---��ֵc    _Phase---��λֵd
                float3 color = 0.5 + 0.5 * cos(UNITY_TWO_PI * (_Oscilate * _Time.y + _Phase));

                float3 finalRGB = mainTex.rgb * color;
                float alpha = mainTex.a;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}