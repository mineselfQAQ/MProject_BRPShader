Shader "MineselfShader/Test/ClipMode_Test1"
{
    Properties
    {
        _Cutout("Cutout", Range(-1, 1)) = -1
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
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            float _Cutout;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 oPos : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.oPos = v.vertex;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float mask = i.oPos.y;

                clip(mask - _Cutout);

                return float4(mask.rrr, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}