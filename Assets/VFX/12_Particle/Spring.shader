Shader "MineselfShader/VFX/12-Particle/Spring"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_EndColor("EndColor", COLOR) = (1,0,0,1)
        _Frequency("Frequency", Float) = 5
        _Amplitude("Amplitude", Float) = 4
        _TimeOffset("TimeOffset", Float) = 0
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

			
            //��������
            sampler2D _MainTex;
            fixed4 _EndColor;
            float _Frequency;
            float _Amplitude;
            float _TimeOffset;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float age : TEXCOORD1;
                float4 color : COLOR;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float age : TEXCOORD1;
                float4 color : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;

                //��ȡ����ʱ��---_TimeOffset��ò��������֮���ƫ��(����ʹ���ʱ�䲻ͬ)
                float t = _Time.y + _TimeOffset;
                float offset = sin(t * _Frequency) * _Amplitude;//y��ƫ��
                v.vertex.y += offset * v.age;//Ӧ��ƫ�ƣ�age---�²಻���ϲද

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.age = v.age;
                o.color = v.color;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                mainTex.rgb *= i.color;

                float3 finalRGB = lerp(mainTex.rgb, _EndColor, i.age);//age---�²�ԭɫ���ϲ�_EndColor
                float alpha = mainTex.a;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}