/**
 * Fight for Australia — Registration Worker
 *
 * Deploy this as a Cloudflare Worker.
 * Optionally bind a KV namespace named REGISTRATIONS to store submissions.
 *
 * Deploy steps:
 * 1. Cloudflare Dashboard → Workers & Pages → Create Worker
 * 2. Paste this code
 * 3. (Optional) Create a KV namespace "ffa-registrations" and bind it as REGISTRATIONS
 * 4. Set a route or custom domain, or use the workers.dev URL
 * 5. Update WORKER_URL in register.html to point to your Worker
 *
 * For notifications you can later add a Discord webhook or Telegram bot.
 */

export default {
  async fetch(request, env, ctx) {
    // CORS for your domain
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*', // tighten to https://fight4australia.org in production
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    };

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    if (request.method !== 'POST') {
      return new Response(JSON.stringify({ error: 'Method not allowed' }), {
        status: 405,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    try {
      const data = await request.json();

      // Basic validation
      if (!data.email || !data.name || !data.consent) {
        return new Response(JSON.stringify({ error: 'Missing required fields' }), {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        });
      }

      const email = String(data.email).trim().toLowerCase();
      const name = String(data.name).trim().slice(0, 100);

      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        return new Response(JSON.stringify({ error: 'Invalid email' }), {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        });
      }

      const record = {
        name,
        email,
        city: data.city || '',
        interest: data.interest || 'Updates only',
        consent: true,
        submittedAt: data.submittedAt || new Date().toISOString(),
        ip: request.headers.get('CF-Connecting-IP') || '',
      };

      // Store in KV if bound
      if (env.REGISTRATIONS) {
        const key = `reg:${Date.now()}:${email}`;
        await env.REGISTRATIONS.put(key, JSON.stringify(record));
      }

      // Optional: send to Discord webhook if you set DISCORD_WEBHOOK_URL as a secret
      if (env.DISCORD_WEBHOOK_URL) {
        ctx.waitUntil(
          fetch(env.DISCORD_WEBHOOK_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              content: `**New registration**\n**Name:** ${name}\n**Email:** ${email}\n**City:** ${record.city || '—'}\n**Interest:** ${record.interest}`,
            }),
          }).catch(() => {})
        );
      }

      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: 'Server error' }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }
  },
};
