Shader "MineselfShader/VFX/4-VertexAnimation/Flip"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Float) = 1
        _Int("Intensity", Float) = 1

        [HideInInspector]_Cutoff("Cutoff", Range(0, 1)) = 0.5
        [HideInInspector]_Color("Color", Color) = (1,1,1,1)
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
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex;
            float _Speed;
            float _Int;
            //����������������Fallback---����aͨ�����޳��Ѿ����ü�����
            float _Cutoff;
            fixed4 _Color;
                
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

                //���㶯������
                float mask = distance(v.vertex.y, -0.5);//���֣����������֣���Ϊ0����Ϊ1
                float t = frac(_Time.y * _Speed);
                v.vertex.x += sin(t * UNITY_TWO_PI) * _Int * mask;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                
                clip(mainTex.a - _Cutoff);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback "Transparent/Cutout/VertexLit"
}