Shader "MineselfShader/VFX/11-ScreenUV/ScreenUV3"
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
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                o.screenPos = ComputeScreenPos(o.pos);//�ؼ�---������Ļ�ռ�����

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 screenPos = i.screenPos;
                float aspect = _ScreenParams.y / _ScreenParams.x;//���㳤���
                screenPos.y *= aspect;//Ӧ�ó����
                screenPos.xy *= _Scale;//����

                //SAMPLE_DEPTH_TEXTURE_PROJ---�󲿷�����¾���tex2Dproj()
                //UNITY_PROJ_COORD---�󲿷������ֱ�ӷ���
                float4 mainTex = SAMPLE_DEPTH_TEXTURE_PROJ(_MainTex, UNITY_PROJ_COORD(screenPos));//����͸�ӳ�������������
                
                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}