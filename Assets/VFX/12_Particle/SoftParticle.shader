Shader "MineselfShader/VFX/12-Particle/SoftParticle"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _EdgeWidth("EdgeWidth", Float) = 1
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
            sampler2D _CameraDepthTexture;

            sampler2D _MainTex;
            float _EdgeWidth;
                
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
                o.screenPos = ComputeScreenPos(o.pos);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                //��۲�ռ��������ֵ
                float screenZRaw = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)).r;
                float eyeZLinear = LinearEyeDepth(screenZRaw);

                //���Ե
                //���У�i.screenPos.w---ָ���ǲü��ռ������������ֵ
                //������������ܵõ���Ե0�����߲�Խ��ֵԽ���һ������
                float edgeMask = saturate((eyeZLinear - i.screenPos.w) / _EdgeWidth);
                
                float3 finalRGB = mainTex.rgb;
                float alpha = mainTex.a * edgeMask;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}