Shader "MineselfShader/Test/ClipMode_Test2"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout" 
            "IgnoreProjector"="True"
        }
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
            fixed4 _Color;
                
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
                mainTex.rgb = 1 - mainTex.rgb;

                float3 finalRGB = mainTex.rgb;
                finalRGB = lerp(finalRGB, _Color, finalRGB);

                clip(mainTex.a - 0.5);
                clip(mainTex.r - 0.5);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}