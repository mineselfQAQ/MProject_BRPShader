Shader "MineselfShader/VFX/1-ABACAD/AC"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Cutoff("CutoffValue", Range(0, 1)) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            ZWrite Off
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex;
            float _Cutoff;
                
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

                clip(mainTex.a - _Cutoff);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}