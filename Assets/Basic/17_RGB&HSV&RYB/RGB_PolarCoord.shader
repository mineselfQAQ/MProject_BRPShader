Shader "MineselfShader/Basic/17-RGB&HSV&RYB/RGB_PolarCoord"
{
    Properties
    {
        _Value("Value", Range(0, 1)) = 1
        _Rotation("Rotation", Range(0, 1)) = 0
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
            #include "..\..\_Common\MyLib.cginc"
			
            //��������
            float _Value;
            float _Rotation;
                
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
                //�����Ȼ�ýǶȺͰ뾶
                float2 polarParams = Rect2Polar(i.uv, float2(0.5, 0.5));
                //ͨ���Ƕ�������ɫ�࣬�뾶�����Ʊ��Ͷȣ�����ü�������ʽ
                float3 finalRGB = HSV2RGB(float3(polarParams.x + 0.5 + _Rotation, polarParams.y, _Value));

                float alpha = step(polarParams.y, 1);//�޳�����Ϊɫ��

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}