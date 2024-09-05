Shader "MineselfShader/VFX/11-ScreenUV/ScreenUV1Pro"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
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
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 clipPos : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //��ü��ռ����궥��λ����Ϣ
                o.clipPos = o.pos;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //��ƬԪ��ɫ���м�����Ļ�ռ䶥��λ����Ϣ
                float2 screenUV = i.clipPos.xy / i.clipPos.w;//͸�ӳ���
                screenUV.y *= _ProjectionParams.x;//��������---���������תy��
                screenUV = screenUV * 0.5 + 0.5;//[-1,1]--->[0,1]
                float aspect = _ScreenParams.y / _ScreenParams.x;//��������---����ȼ���
                screenUV.y *= aspect;//��������---Ӧ�ó����
                screenUV *= _Scale;//����

                float4 mainTex = tex2D(_MainTex, screenUV);
                
                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}