import numpy as np


def periodic_center_of_mass(pos, box_size, mass=None):
    """Calculate center of mass considering periodic boundary conditions.

    Parameters
    ----------
    pos : array_like, shape=[n_particles, n_dim]
        Particle position array.
    box_size : array_like, shape=[n_dim]
        Box size in each dimension.
    mass : array_like, shape=[n_particles], optional
        Particle mass array. If `mass=None`, then all particle masses are
        assumed to be the same.

    Returns
    -------
    array_like
        The center of mass coordinates.

    References
    ----------
    The algorithm is described in [1]_. A summery can be found on `Wikipedia`_.

    .. _Wikipedia: https://en.wikipedia.org/wiki/Center_of_mass#Systems_with_periodic_boundary_conditions

    .. [1] L. Bai & D. Breen, "Calculating Center of Mass in an Unbounded
       2D Environment", Journal of Graphics Tools, 13:4, 53-60, 2008.
       doi:10.1080/2151237X.2008.10129266

    """
    theta = pos / box_size * (2 * np.pi)
    x = np.cos(theta)
    y = np.sin(theta)
    x_mean = np.average(x, weights=mass, axis=0)
    y_mean = np.average(y, weights=mass, axis=0)
    theta_mean = np.arctan2(-y_mean, -x_mean) + np.pi
    com = box_size * (theta_mean / (2 * np.pi))
    return com
