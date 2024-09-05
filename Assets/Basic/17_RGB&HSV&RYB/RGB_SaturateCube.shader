Shader "MineselfShader/Basic/17-RGB&HSV&RYB/RGB_SaturateCube"
{
    Properties
    {
        _Saturate("Saturate", Range(0, 1)) = 1
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
            float _Saturate;
                
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
                //���ģ�Ҳ��Ψһ��һ��
                //����HSV��תΪRGB����ʾ����
                //����uv�����ṩ����ά�ȣ�����һ��ά����Ҫʹ��һ����������
                return float4(HSV2RGB(float3(i.uv.x, _Saturate, i.uv.y)), 1);
            }
            ENDCG
        }
    }
    Fallback Off
}