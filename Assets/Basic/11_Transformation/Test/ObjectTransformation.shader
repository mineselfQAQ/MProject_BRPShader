Shader "MineselfShader/Test/ObjectTransformation"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Translation("Translation", vector) = (0,0,0,0)
        _Rotation("Rotation", Float) = 1
        _Scale("Scale", vector) = (1,1,1,0)
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

			
            //��������
            sampler2D _MainTex;
            float3 _Scale;
            float _Rotation;
            float3 _Translation;
                
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

                v.vertex.xyz *= _Scale;
                
                v.vertex.xyz += _Translation;

                float t = frac(_Time.x * _Rotation) * UNITY_TWO_PI;
                float3x3 rM = float3x3(cos(t),  0, sin(t),
                                           0,   1,     0,
                                      -sin(t),  0, cos(t));
                v.vertex.xyz = mul(rM, v.vertex.xyz);

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

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