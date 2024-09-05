Shader "MineselfShader/Basic/17-RGB&HSV&RYB/DotWheel"
{
    Properties
    {
        [Header(Common)][Space(5)]
        _Speed("Speed", Float) = 1
        [IntRange]_ChangeDirection("ChangeDirection", Range(0, 1)) = 0
        [Header(DotSettings)][Space(5)]
        [IntRange]_DotAmount("DotAmount", Range(1, 32)) = 16
        _DotSize("DotSize", Range(0.01, 1)) = 0.5
        _DotBlur("DotBlur", Range(0, 0.2)) = 0.02
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
            float _Speed;
            float _ChangeDirection;
            float _DotAmount;
            float _DotSize;
            float _DotBlur;
                
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
                //���ٶ�
                float speed = lerp(_Speed, -_Speed, _ChangeDirection);
                float t = frac(_Time.x * speed);

                //��ü�������ʽ
                float2 polarParams = Rect2Polar(i.uv, float2(0.5, 0.5));

                //���ɫ��---������Ҫ��ɫ������SVֵ��Ϊ1
                float3 finalRGB = HSV2RGB(float3(polarParams.x + t, 1, 1));

                //�����޳�
                float2 dotUV = frac(i.uv * _DotAmount);
                float dotMask = DrawCircle(dotUV, _DotSize, _DotBlur * _DotAmount);
                float alpha = step(polarParams.y, 1) * dotMask;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}