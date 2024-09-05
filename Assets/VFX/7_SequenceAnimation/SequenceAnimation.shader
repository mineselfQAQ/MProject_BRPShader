Shader "MineselfShader/VFX/7-SquenceAnimation/SequenceAnimation"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Row("Row", Float) = 0
        _Column("Column", Float) = 0
        _Speed("Speed", Range(0, 2)) = 1
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
            float _Row;
            float _Column;
            float _Speed;
                
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

                //����ʱ��
                float t = floor(frac(_Time.y * _Speed) * _Row * _Column);

                //���㵱ǰ����
                float row = floor(t / _Column);//ִ����һ���е���������(n��)��ִ����һ��
                float column = fmod(t, _Column);//ִ����һ���ִ�еڶ���

                //���㵱ǰ����uv
                //����˼���ȽϺ���⣺
                //uvÿ�������ȡֵ��ΧΪ[0,1]����Ҫ���ǵ�ǰ���ڵ�λ�ã�
                //����˵�ڶ��У���ô����[1,2]����ʱ�ٳ��������õ���[0,1]֮�������
                float U = (v.uv.x + column) / _Column;
                float V = (v.uv.y - 1 - row) / _Row;//uv��Ҫ�����ƶ�һ����ǽ����Ͻ���Ϊ��ʼ

                o.uv = float2(U, V);

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