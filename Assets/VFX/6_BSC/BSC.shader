Shader "MineselfShader/VFX/6-BSC/BSC"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Brightness("Brightness", Range(0, 2)) = 1
        _Saturate("Saturate", Range(0, 2)) = 1
        _Contrast("Contrast", Range(0, 2)) = 1
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
            float _Brightness;
            float _Saturate;
            float _Contrast;
                
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
                float4 mainTex = tex2D(_MainTex, i.uv);

                //B---Brightness
                mainTex.rgb *= _Brightness;

                //S---Saturate
                float luminance = 
                    0.2125 * mainTex.r + 0.7154 * mainTex.g + 0.0721 * mainTex.b;
                float3 saturatedMainTex = luminance.rrr;
                mainTex.rgb = lerp(saturatedMainTex, mainTex.rgb, _Saturate);

                //C---Contrast
                float3 avgCol = float3(0.5, 0.5, 0.5);
                mainTex.rgb = (mainTex.rgb - avgCol) * _Contrast + avgCol;


                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}