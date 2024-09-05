Shader "MineselfShader/VFX/9-PolarCoord/Distort_Polar"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 10)) = 1
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
            #include "..\..\_Common\MyLib.cginc"
			
            //��������
            sampler2D _MainTex; float4 _MainTex_ST;
            fixed4 _Color;
            float _Speed;
            float _Int;
            
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
                
                //�������Ų�����������Ҫ����ͼ���Ĵ����ţ�������Ҫ�Ƚ���λ�Ʋ���
                v.uv -= 0.5;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv += 0.5;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //����---ת����������ϵ���м���
                //ע��:���²��������ڶ�����ɫ���н��У���Ϊ�ڶ�����ɫ���л�δ���в�ֵ����
                //��Quadֻ��4��������Ϣ�����޷��������²�����
                float2 polarParms = Rect2Polar(i.uv, float2(0.5, 0.5));
                float u = polarParms.x + frac(_Time.x * _Speed) * polarParms.y * _Int;//����
                float v = polarParms.y;//Զ��
                float2 polarUV = float2(u, v);

                float4 mainTex = tex2D(_MainTex, polarUV);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}