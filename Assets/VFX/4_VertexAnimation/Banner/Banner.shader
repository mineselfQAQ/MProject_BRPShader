Shader "MineselfShader/VFX/4-VertexAnimation/Banner"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 2)) = 1
        _Int("Intensity", Float) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            Cull Off//��Ҫ��ʾ���ĵı��棬��Ҫ�رձ����޳�
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex; float4 _MainTex_ST;
            float _Speed;
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


                //�������İڶ�
                float mask = v.uv.x;//������uvӦ��������(0,0)����(1,1)����ôuv.x������0��1
                float t = frac(_Time.y * _Speed);
                v.vertex.x += sin((t + v.vertex.z) * UNITY_TWO_PI) * _Int * mask;//��Ҫע����������x��z�Ǹ���������������������

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}