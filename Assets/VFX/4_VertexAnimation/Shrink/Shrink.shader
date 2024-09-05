Shader "MineselfShader/VFX/4-VertexAnimation/Shrink"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 2)) = 1
        _Min("Min", Float) = -1
        _Max("Max", Float) = 1
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
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��
            #include "..\..\..\_Common\MyLib.cginc"
			
            //��������
            sampler2D _MainTex; float4 _MainTex_ST;
            float _Speed;
            float _Min;
            float _Max;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
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

                //����ʱ��
                float t = sin(frac(_Time.y * _Speed) * UNITY_TWO_PI);
                t = Remap(t, -1, 1, _Min, _Max);//ԭ��ֵ��[-1,1]����������Ĭ��λ�Ƶı��ʣ�ֱ����ӳ�伴��
                //�����ĺ���---�ط��߷����ƶ�һ�ξ���
                v.vertex.xyz += v.normal * t;

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
    Fallback Off
}