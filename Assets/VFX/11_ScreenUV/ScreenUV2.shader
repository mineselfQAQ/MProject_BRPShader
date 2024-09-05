Shader "MineselfShader/VFX/11-ScreenUV/ScreenUV2"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Scale("Scale", vector) = (1,1,0,0)
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
            float2 _Scale;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //�������
            struct v2f {};//�����pos�����˶�����ɫ��������---��Ϊ��Ҫʹ��out���Բ���д�ڶ������

            //������ɫ��
            v2f vert (appdata v, out float4 pos : SV_POSITION)
            {
                v2f o;

                pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
            {
                //ֱ�ӻ�ȡ��Ļ�ռ�UV
                float2 screenUV = screenPos.xy;
                screenUV = screenUV * 0.01 * _Scale;//������ʼ״̬��ͼ̫С�ˣ�������Ҫ����0.01ʹ����

                float4 mainTex = tex2D(_MainTex, screenUV);
                
                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}