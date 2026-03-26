import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  try {
    const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')
    const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    if (!GEMINI_API_KEY || !SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
      throw new Error("Faltam variáveis de ambiente!")
    }

    const prompt = "Gere uma única palavra em português que seja inspiradora e relacionada ao universo da música (ex: Melodia, Ritmo, Saudade). Responda apenas com a palavra, sem pontuação."
    
    const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }]
      })
    })

    const data = await response.json()
    const aiWord = data.candidates[0].content.parts[0].text.trim()

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

    const { error } = await supabase
      .from('daily_words')
      .insert({ 
        word: aiWord, 
        created_at: new Date().toISOString().split('T')[0] 
      })

    if (error) {
      console.log("Aviso ou Erro ao inserir:", error.message)
    }

    return new Response(JSON.stringify({ word: aiWord }), { 
      headers: { "Content-Type": "application/json" } 
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { 
      status: 500,
      headers: { "Content-Type": "application/json" } 
    })
  }
})
