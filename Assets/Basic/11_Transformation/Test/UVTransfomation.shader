Shader "MineselfShader/Test/UVTransformation"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Pivot("Pivot", vector) = (0.5,0.5,0,0)
        _Translation("Translation", vector) = (0,0,0,0)
        _Rotation("Rotation", Float) = 1
        _Scale("Scale", vector) = (1,1,0,0)
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
            float2 _Pivot;
            float2 _Translation;
            float _Rotation;
            float2 _Scale;
                
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

                o.uv -= _Pivot;

                ////������תƽ��
                o.uv *= _Scale;
                
                float t = frac(_Time.x * _Rotation) * UNITY_TWO_PI;
                float2x2 rM = float2x2(cos(t), -sin(t),
                                       sin(t), cos(t));
                o.uv = mul(rM, o.uv);

                o.uv -= _Translation;

                o.uv += _Pivot;

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