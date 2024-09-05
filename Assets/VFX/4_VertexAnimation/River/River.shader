Shader "MineselfShader/VFX/4-VertexAnimation/Water"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _FlowSpeed("FlowSpeed", Float) = 1
        _Prarms("X:Speed Y:Intensity Z:Scale", vector) = (1,1,1,0)
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            Cull Off//��Ҫ��ʾˮ�ı��棬��Ҫ�رձ����޳�

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex; float4 _MainTex_ST;
            float _FlowSpeed;
            float3 _Prarms;
                
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

                //sin()�˶�
                float t = frac(_Time.y * _Prarms.x);
                v.vertex.y += sin((t + v.vertex.z * _Prarms.z) * UNITY_TWO_PI) * _Prarms.y;

                o.pos = UnityObjectToClipPos(v.vertex);

                //UV����
                v.uv = float2(v.uv.y, v.uv.x);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.y += frac(_Time.y * _FlowSpeed);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                clip(mainTex.a - 0.7);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}