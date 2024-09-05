Shader "MineselfShader/VFX/5-UVAnimation/Dot"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 0
        _SizeParams("DotNums", vector) = (16, 9, 0, 0)
        _Int("Intensity", Range(0, 1)) = 0
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
            float _TimeSwitch;
            float2 _SizeParams;
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

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //����ʱ��
                float t = lerp(_Int, frac(_Time.y * _Int), _TimeSwitch);

                //��������
                float dotMask = distance(frac(i.uv * _SizeParams.xy), float2(0.5, 0.5));//СԲ������
                float lineMask = i.uv.x;//��0��1����
                float finalMask = step(t * 2, dotMask + lineMask);//����������Ӻ�ȡֵ��Χ[0,2]�����Զ���[0,1]��t��Ҫ��2

                float4 mainTex = tex2D(_MainTex, i.uv);

                float3 finalRGB = mainTex.rgb;
                float alpha = 1 - finalMask;//��Ҫ_Int��0��1Ϊ���޵��У�������Ҫʹ��һ��

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}