using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FinalidadeController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public FinalidadeController(RouterDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Finalidade>>> GetFinalidades()
        {
            return await _context.Finalidades.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Finalidade>> GetFinalidade(int id)
        {
            var finalidade = await _context.Finalidades.FindAsync(id);

            if (finalidade == null)
            {
                return NotFound();
            }

            return finalidade;
        }
    }
}
