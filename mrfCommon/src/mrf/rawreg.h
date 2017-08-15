/*************************************************************************\
* Copyright (c) 2017 Michael Davidsaver
* mrfioc2 is distributed subject to a Software License Agreement found
* in file LICENSE that is included with this distribution.
\*************************************************************************/
#ifndef RAWREG_H
#define RAWREG_H

namespace mrf {

class RawRegisterAccess
{
public:
    virtual ~RawRegisterAccess() {}

    enum access_t {
        NoAccess,
        Read,
        Write,
        ReadWrite,
    };

    /** Request for offset in a certain region
     *
     * On success, assigned *addr and *perm
     * On failure throws std::runtime_error
     */
    virtual void getRegisterOffset(unsigned region,
                                   unsigned offset,
                                   volatile void** addr,
                                   access_t* perm);
};

} // namespace mrf

#endif // RAWREG_H
