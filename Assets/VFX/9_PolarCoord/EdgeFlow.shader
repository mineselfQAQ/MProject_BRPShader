Shader "MineselfShader/VFX/9-PolarCoord/EdgeFlow"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        [Toggle]_Invert("InvertDirection", Float) = 0
        _Speed("Speed", Float) = 1
        [Space(10)]
        _Scale("Scale", Float) = 1
        _Radius("Radius", Float) = 1
        _Width("Width", Range(0, 0.5)) = 0
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
			#pragma shader_feature _INVERT_ON

            //��������
            sampler2D _MainTex; float4 _MainTex_ST;
            fixed4 _Color;
            float _Speed;
            float _Scale;
            float _Radius;
            float _Width;
            
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
                float2 polarParms = Rect2Polar(i.uv, float2(0.5, 0.5));

                //���Ʒ���Ĭ�������Ӧ������ʱ����ת��ʹ��һ����Ϳ��Ա�Ϊ˳ʱ����ת
                #if _INVERT_ON
                  polarParms.x = 1 - polarParms.x;
                #endif
                //u---����
                //����Ϊ��������ת����
                //�����ʹ�ü򵥵���ת��������
                //����ʹ�õķ�����Ҫ��frac()���鿴frac()�������ӻ��Ϳ���֪��������ʲô
                float u = frac(frac(polarParms.x - (_Time.y * _Speed)) * _Scale);

                //v---Զ��
                //����һ�����������ֻ��Ҫһ�����볡���������ﲻ��
                //������Ҫ����Χӳ�䵽һ���пջ���
                //ͨ�����·������Եõ�smoothV---�а���ڣ������м��smoothstep()���ɾ���������Ҫ������
                float v = polarParms.y;
                float smoothV = 1 - smoothstep(0, _Radius, v);
                smoothV = Remap(smoothV, _Width, 1 - _Width, 0, 1);

                //����ֻ��ҪsmoothV��0��1֮��Ĺ��ɲ���
                //�����������aͨ����ֵ
                //ע�⣺ͨ��smoothV * (1 - smoothV)�����ܵõ��������򣬴�ʱ��������Ϊһ���Ƚ�С��ֵ�����඼Ϊ0
                //     ������Ҫͨ����������Ϊ0��1---�Ǻڼ���
                float alphaMask = smoothV * (1 - smoothV);
                alphaMask = saturate(alphaMask * 10);

                //�ϲ�uv
                float2 polarUV = float2(u, smoothV);
                float4 mainTex = tex2D(_MainTex, polarUV);

                float3 finalRGB = mainTex.rgb * _Color;
                float alpha = mainTex.r * alphaMask;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}